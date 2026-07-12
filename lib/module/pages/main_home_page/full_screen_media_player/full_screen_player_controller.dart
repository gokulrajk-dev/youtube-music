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
import 'full_screen_player_controller.dart';

enum direction  {
  left,right
}

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
  late PageController pageControllerMini;
  late PageController pageControllerFull;
  int? lastsong;
  bool _isSyncing = false;
  final  showSeek=false.obs;
  final seekValue=0.obs;
  Timer? _seekOverlayTimer;
  final seekDirection = direction.left.obs;
  final RxList<Song> songsFilter = <Song>[].obs;
  final Song_Repository song_repository = Song_Repository();
  final isRecom =false.obs;
  final genreIndex=0.obs;

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

    pageControllerMini.addListener((){
      _sync(pageControllerMini, pageControllerFull);
    });


    pageControllerFull.addListener((){
      _sync(pageControllerFull, pageControllerMini);
    });

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
    pageControllerFull.dispose();
    pageControllerMini.dispose();
    _seekOverlayTimer?.cancel();
    super.onClose();
  }

  // void autoNextPage() {
  //   ever(song.currentIndex, (index) async {
  //     if (!pageController.hasClients) return;
  //
  //     final currentPage = pageController.page?.round();
  //
  //     final newsong = song.queue[index];
  //
  //     // 🚫 SAME SONG → ignore (reorder case)
  //     if (lastsong == newsong.id) {
  //       // still sync UI if needed
  //       if (currentPage != index) {
  //         pageController.animateToPage(
  //           index,
  //           duration: const Duration(milliseconds: 300),
  //           curve: Curves.easeInOut,
  //         );
  //       }
  //       return;
  //     }
  //
  //     // 🔥 Detect USER SWIPE vs SYSTEM CHANGE
  //     // final isUserSwipe = currentPage == index;
  //
  //     lastsong = newsong.id;
  //     if (song.isReordering.value) return;
  //     // 🎯 ONLY CALL API on swipe / next / previous
  //
  //     await song.get_current_user_pick_song(newsong.id);
  //
  //     if (currentPage != index) {
  //       pageController.animateToPage(
  //         index,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   });
  // }

  void _sync(PageController source,PageController target){
    if(_isSyncing)return;
    _isSyncing =true;
    if(target.hasClients &&  source.hasClients){
      target.position.jumpTo(source.offset);
    }
    _isSyncing=false;
  }
  void autoNextPage() {
    ever(song.currentIndex, (index) async {
      final newsong = song.queue[index];
      if(pageControllerMini.hasClients){
        // this is to animated page is not works for here
        // pageControllerMini.animateToPage(
        //   index,
        //   duration: const Duration(milliseconds: 300),
        //   curve: Curves.easeInOut,
        // );
        //this is the correct code for here
        pageControllerMini.jumpToPage(index);
      }if(pageControllerFull.hasClients){
        // pageControllerFull.animateToPage(
        //   index,
        //   duration: const Duration(milliseconds: 300),
        //   curve: Curves.easeInOut,
        // );
        pageControllerFull.jumpToPage(index);
      }

      if (song.isReordering.value) return;
      // 🎯 ONLY CALL API on swipe / next / previous

      await song.get_current_user_pick_song(newsong.id);
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
  void _showSeekOverlay(int seconds,direction directions) {
    seekDirection.value = directions;
    seekValue.value += seconds;
    showSeek.value = true;


    _seekOverlayTimer?.cancel();

    _seekOverlayTimer = Timer(
      const Duration(milliseconds: 700),
          () {
        showSeek.value = false;
        seekValue.value=0;
      },
    );
  }

  Future<void> leftSeekJump() async {
    final current = position.value;
    final target = current - const Duration(seconds: 10);

    _showSeekOverlay(-10,direction.left);

    await audioPlayer.seek(
      target.isNegative ? Duration.zero : target,
    );

  }

  Future<void> rightSeekJump() async {
    final current =position.value;
    final total = duration.value;

    var target = current + const Duration(seconds: 10);

    if (target > total) {
      target = total;
    }

    _showSeekOverlay(10,direction.right);

    await audioPlayer.seek(target);

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
  // recommentation code
  Future<void> get_all_songsFilter(String language,String genre) async {
    try {
      get_isloading(true);
      noerror();
      final result = await song_repository.Song_Filter(language,genre);
      songsFilter.value = result;
    } catch (e) {
      get_error(e.toString());
    } finally {
      get_isloading(false);
    }
  }

  void Recommentation_on_off(bool value){
    isRecom.value=value;
  }

  void changeGenreIndex(int index){
    genreIndex.value = index;
  }


}
