import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_music/core/base/base_controller.dart';
import 'package:youtube_music/data/user_respository/user_history_respository.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';
import 'package:youtube_music/services/audio_helper/audio_helper.dart';

import '../../../../data/data_module/song_module.dart';
import '../../../../data/user_respository/song_respository.dart';

enum direction { left, right }

class full_screen_media_player_controller extends base_controller
    with GetSingleTickerProviderStateMixin {
  // ───────────────────────── CONSTANTS ─────────────────────────
  // Pulled out of method bodies so the "magic numbers" are named and
  // only need to change in one place.
  static const _seekJumpDuration = Duration(seconds: 10);
  static const _seekOverlayVisibleDuration = Duration(milliseconds: 700);
  static const _pageAnimDuration = Duration(milliseconds: 300);
  static const _historyThresholdSeconds = 30;
  static const _maxCountablePositionJumpMs = 5000; // ignore seek jumps

  /// ✅ AUDIO SERVICE CONTROLLER
  final MyAudioController audioPlayer = Get.find<MyAudioController>();

  final get_current_song song = Get.find<get_current_song>();

  /// UI STATE
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> buffer_position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final isplaying = false.obs;

  /// SUBSCRIPTIONS
  late final StreamSubscription positionSub;
  late final StreamSubscription bufferSub;
  late final StreamSubscription durationSub;
  late final StreamSubscription playerStateSub;

  /// WORKERS
  // `ever()` returns a Worker that is NOT auto-disposed by GetX. Keeping the
  // old code's un-stored `ever(...)` calls meant every controller rebuild
  // (e.g. hot-restart-free navigation back to this page) would stack a new
  // listener on top of the previous one, since the old one was never torn
  // down in onClose. That silently multiplies API calls and animations the
  // longer the app runs. Storing + disposing them fixes that leak.
  late final Worker _songChangeWorker;
  late final Worker _pageSyncWorker;

  /// HISTORY TRACKING
  Duration lastPosition = Duration.zero;
  int listenedMilliseconds = 0;
  bool historySent = false;

  final UserHistoryCrud historyCrud = UserHistoryCrud();

  late final AnimationController animationController;
  late final PageController pageControllerMini;
  late final PageController pageControllerFull;
  bool _isSyncing = false;
  final showSeek = false.obs;
  final seekValue = 0.obs;
  Timer? _seekOverlayTimer;
  final seekDirection = direction.left.obs;
  final RxList<Song> songsFilter = <Song>[].obs;
  final Song_Repository song_repository = Song_Repository();
  final isRecom = false.obs;
  final genreIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageControllerMini = PageController(
      initialPage: song.currentIndex.value,
      viewportFraction: 1,
    );
    pageControllerFull = PageController(
      initialPage: song.currentIndex.value,
      viewportFraction: 1,
    );

    pageControllerMini.addListener(() {
      _sync(pageControllerMini, pageControllerFull);
    });

    pageControllerFull.addListener(() {
      _sync(pageControllerFull, pageControllerMini);
    });



    animationController = AnimationController(
      vsync: this,
      duration: _pageAnimDuration,
    );

    /// 🎯 POSITION STREAM
    positionSub = audioPlayer.positionStream.listen(_onPositionTick);

    /// 🎯 BUFFER STREAM
    bufferSub = audioPlayer.bufferedPositionStream.listen((buf) {
      buffer_position.value = buf;
    });

    /// 🎯 DURATION STREAM
    durationSub = audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur;
      }
    });

    /// 🎯 PLAYER STATE (SYNC WITH NOTIFICATION)
    playerStateSub = audioPlayer.playerStateStream.listen((state) async {
      isplaying.value = state.playing;
      play_pause_animation();

      if (state.processingState == ProcessingState.completed) {
        // This must be false BEFORE play_Next() runs, since play_Next()
        // changes current_song/currentIndex, and both _songChangeWorker and
        // _bindQueueIndexToPages bail out early when isReordering is true.
        song.isReordering.value = false;

        final isLastSong = song.currentIndex.value == song.queue.length - 1;

        if (isLastSong && songsFilter.isNotEmpty) {
          song.queue.add(songsFilter.removeAt(0));
          await song.play_Next();
        }

      }
    });

    _pageSyncWorker = _bindQueueIndexToPages();

    /// 🎯 SONG CHANGE
    _songChangeWorker = ever<Song?>(song.current_song, (newSong) async {
      if (newSong != null && !song.isReordering.value) {
        resetPosition();
        await playSong();
      }
    });

    pauseForDevelopment();
  }

  @override
  void onClose() {
    positionSub.cancel();
    bufferSub.cancel();
    durationSub.cancel();
    playerStateSub.cancel();
    _songChangeWorker.dispose();
    _pageSyncWorker.dispose();
    animationController.dispose();
    pageControllerFull.dispose();
    pageControllerMini.dispose();
    _seekOverlayTimer?.cancel();
    super.onClose();
  }

  /// Keeps the mini/full page views on the currently playing queue index and
  /// notifies the backend which song the user is on (skipped while a
  /// drag-reorder is in progress).
  Worker _bindQueueIndexToPages() {
    return ever<int>(song.currentIndex, (index) async {
      if (index < 0 || index >= song.queue.length) return;
      final newsong = song.queue[index];

      if (pageControllerMini.hasClients) {
        pageControllerMini.jumpToPage(index);
      }
      if (pageControllerFull.hasClients) {
        pageControllerFull.jumpToPage(index);
      }

      if (song.isReordering.value) return;

      // 🎯 ONLY CALL API on swipe / next / previous
      await song.get_current_user_pick_song(newsong.id);
    });
  }

  void _sync(PageController source, PageController target) {
    if (_isSyncing) return;
    if (!target.hasClients || !source.hasClients) return;
    _isSyncing = true;
    target.position.jumpTo(source.offset);
    _isSyncing = false;
  }

  /// Extracted out of onInit's inline closure purely for readability — same
  /// behavior as before, just testable/readable on its own.
  Future<void> _onPositionTick(Duration pos) async {
    position.value = pos;

    if (audioPlayer.playing) {
      final diff = pos - lastPosition;

      if (diff.inMilliseconds > 0 &&
          diff.inMilliseconds < _maxCountablePositionJumpMs) {
        listenedMilliseconds += diff.inMilliseconds;
      }

      lastPosition = pos;
    }

    final listenedSeconds = listenedMilliseconds ~/ 1000;

    if (listenedSeconds >= _historyThresholdSeconds && !historySent) {
      // Guard BEFORE the await so a slow response can't let a second tick
      // sneak through and fire a duplicate request (same as original intent,
      // now just guaranteed by ordering rather than luck of the event loop).
      historySent = true;

      final currentSongId = song.current_song.value?.id;
      if (currentSongId == null) return;

      try {
        await historyCrud.post_user_song_histroy(
          currentSongId,
          listenedSeconds,
        );
      } catch (e) {
        debugPrint("❌ API ERROR: $e");
        // Left as "sent" on failure (matches original behavior) to avoid
        // hammering the endpoint every tick if it's down. Flip this to
        // `historySent = false;` if you'd rather retry on the next tick.
      }
    }
  }

  /// 🧪 DEBUG
  Future<void> pauseForDevelopment() async {
    if (kDebugMode) {
      await audioPlayer.pause();
      debugPrint('🔇 Audio paused for faster hot reload');
    }
  }

  /// 🔄 RESET
  void resetPosition() {
    position.value = Duration.zero;
    buffer_position.value = Duration.zero;
    duration.value = Duration.zero;
    listenedMilliseconds = 0;
    historySent = false;
    lastPosition = Duration.zero;
  }

  /// ▶️ PLAY SONG
  Future<void> playSong() async {
    final songData = song.current_song.value;
    final hlsUrl = songData?.stream?.hlsMasterUrl;

    if (songData == null || hlsUrl == null) {
      debugPrint("❌ playSong(): no current song or missing stream URL");
      return;
    }

    final base = dotenv.env['API_BASE_URL'];
    if (base == null) {
      debugPrint("❌ playSong(): API_BASE_URL missing from .env");
      return;
    }

    final fullUrl = "$base$hlsUrl";
    await audioPlayer.playSong(fullUrl, songData);
  }

  /// ⏩ SEEK to an absolute position, clamped to the track's duration.
  Future<void> control_seek(Duration seekTo) async {
    if (duration.value <= Duration.zero) return;

    final safeSeek = Duration(
      microseconds: seekTo.inMicroseconds.clamp(
        0,
        duration.value.inMicroseconds,
      ),
    );

    await audioPlayer.seek(safeSeek);
  }

  void _showSeekOverlay(int seconds, direction directions) {
    seekDirection.value = directions;
    seekValue.value += seconds;
    showSeek.value = true;
    _seekOverlayTimer?.cancel();

    _seekOverlayTimer = Timer(_seekOverlayVisibleDuration, () {
      showSeek.value = false;
      seekValue.value = 0;
    });
  }

  /// ⏪ / ⏩ relative jumps now both funnel through `control_seek`, so the
  /// clamping logic lives in exactly one place instead of being duplicated
  /// (and duplicated slightly differently — the old rightSeekJump clamped
  /// manually while control_seek did too) across three methods.
  Future<void> leftSeekJump() async {
    _showSeekOverlay(-10, direction.left);
    await control_seek(position.value - _seekJumpDuration);
  }

  Future<void> rightSeekJump() async {
    _showSeekOverlay(10, direction.right);
    await control_seek(position.value + _seekJumpDuration);
  }

  /// 🎬 ANIMATION
  void play_pause_animation() {
    if (isplaying.value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  /// ⏯️ PLAY / PAUSE BUTTON
  Future<void> togglePlayPause() async {
    if (isplaying.value) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
  }

  // recommendation code
  Future<void> get_all_songsFilter(String language, String genre) async {
    try {
      get_isloading(true);
      noerror();
      final result = await song_repository.Song_Filter(language, genre);
      songsFilter.value = result;
    } catch (e) {
      get_error(e.toString());
    } finally {
      get_isloading(false);
    }
  }

  void Recommentation_on_off(bool value) {
    isRecom.value = value;
  }

  void changeGenreIndex(int index) {
    genreIndex.value = index;
  }
}