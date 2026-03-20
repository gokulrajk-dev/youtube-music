import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_music/data/user_respository/user_history_respository.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';

class full_screen_media_player_controller extends GetxController with GetSingleTickerProviderStateMixin{
  final AudioPlayer audioPlayer = AudioPlayer();
  final get_current_song song = Get.find<get_current_song>();
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> buffer_position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final isshuffleenabled = false.obs;
  late StreamSubscription positionSub;
  late StreamSubscription BufferSub;
  late StreamSubscription durationSub;
  Duration lastPosition = Duration.zero;
  int listenedMilliseconds = 0;
  bool historySent = false;
  final UserHistoryCrud historyCrud =UserHistoryCrud();
  late AnimationController animationController;
  final isplaying = false.obs;

  @override
  void onInit()  {
    steam_position();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    BufferSub =audioPlayer.bufferedPositionStream.listen((bufpos) {
      if(duration.value == buffer_position.value) return;
      buffer_position.value = bufpos;
    });

    durationSub =audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur;
      }
    });

    audioPlayer.shuffleModeEnabledStream.listen((enable) {
      isshuffleenabled.value = enable;
    });

    audioPlayer.playerStateStream.listen((playing) {
      isplaying.value = playing.playing;
      play_pause_controller();
    });

    ever(song.current_song, (newSong) {
      if (newSong != null) {
        reset_postion();
        songStream();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    positionSub.cancel();
    BufferSub.cancel();
    durationSub.cancel();
    audioPlayer.dispose();
    super.onClose();
  }

  void reset_postion(){
    position.value = Duration.zero;
    buffer_position.value = Duration.zero;
    duration.value = Duration.zero;
    listenedMilliseconds = 0;
    historySent = false;
    lastPosition = Duration.zero;
  }

  Future<void> songStream()async{
    String songpath ="${song.current_song.value!.stream!.hlsMasterUrl}";
    String songs = dotenv.env['API_BASE_URL']!;
    final fullurl ="$songs$songpath";
    await audioPlayer.stop();
    await audioPlayer.setUrl(fullurl);
    await audioPlayer.play();
  }

  void steam_position() {
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
          print("❌ API ERROR: $e");
        }
      }
    });
  }


  Future<void> control_seek(Duration seekTo) async {

    if (duration.value <= Duration.zero) return;

    final safeSeek = Duration(
      microseconds: seekTo.inMicroseconds.clamp(
        0,
        duration.value.inMicroseconds,
      ),
    );

    if (safeSeek <= buffer_position.value) {
      await audioPlayer.seek(safeSeek);
    }
  }

  Future<void> play_pause_controller() async {
    if (isplaying.value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  Future<void> contorller_for_song() async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
  }

}