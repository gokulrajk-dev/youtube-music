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

class full_screen_media_player_controller extends base_controller
    with GetSingleTickerProviderStateMixin {
  /// ✅ AUDIO SERVICE CONTROLLER
  final MyAudioController audioPlayer = Get.find<MyAudioController>();

  final get_current_song song = Get.find<get_current_song>();

  /// UI STATE
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> buffer_position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final isplaying = false.obs;

  /// SUBSCRIPTIONS
  late StreamSubscription positionSub;
  late StreamSubscription bufferSub;
  late StreamSubscription durationSub;
  late StreamSubscription playerStateSub;

  /// HISTORY TRACKING
  Duration lastPosition = Duration.zero;
  int listenedMilliseconds = 0;
  bool historySent = false;

  final UserHistoryCrud historyCrud = UserHistoryCrud();

  late AnimationController animationController;
  late PageController pageController;
  int? lastsong;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(
      initialPage: song.currentIndex.value,
      viewportFraction: 1,
    );

    autoNextPage();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    /// 🎯 POSITION STREAM
    positionSub = audioPlayer.positionStream.listen((pos) async {
      position.value = pos;

      if (audioPlayer.playing) {
        final diff = pos - lastPosition;

        if (diff.inMilliseconds > 0 && diff.inMilliseconds < 5000) {
          listenedMilliseconds += diff.inMilliseconds;
        }

        lastPosition = pos;
      }

      int listenedSeconds = listenedMilliseconds ~/ 1000;

      if (listenedSeconds >= 30 && !historySent) {
        historySent = true;

        final currentSongId = song.current_song.value!.id;

        try {
          await historyCrud.post_user_song_histroy(
              currentSongId, listenedSeconds);
        } catch (e) {
          debugPrint("❌ API ERROR: $e");
        }
      }
    });

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
        autoNextPage();
      }
    });

    /// 🎯 SONG CHANGE
    ever(song.current_song, (newSong) async {
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
    animationController.dispose();
    pageController.dispose();
    super.onClose();
  }

  void autoNextPage() {
    ever(song.currentIndex, (index) async {
      if (!pageController.hasClients) return;

      final currentPage = pageController.page?.round();

      final newsong = song.queue[index];

      // 🚫 SAME SONG → ignore (reorder case)
      if (lastsong == newsong.id) {
        // still sync UI if needed
        if (currentPage != index) {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        return;
      }


      // 🔥 Detect USER SWIPE vs SYSTEM CHANGE
      final isUserSwipe = currentPage == index;

      lastsong = newsong.id;
      if(song.isReordering.value) return;
      // 🎯 ONLY CALL API on swipe / next / previous
      if (isUserSwipe) {
        await song.get_current_user_pick_song(newsong.id);
      }

      if (currentPage != index) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }

    });
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
    final songData = song.current_song.value!;
    final base = dotenv.env['API_BASE_URL']!;
    final fullUrl = "$base${songData.stream!.hlsMasterUrl}";

    await audioPlayer.playSong(fullUrl, songData);
  }

  /// ⏩ SEEK
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
}
