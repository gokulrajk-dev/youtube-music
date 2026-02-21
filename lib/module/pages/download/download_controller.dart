import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_music/core/base/base_controller.dart';

class download_Controller extends base_controller
    with GetSingleTickerProviderStateMixin {
  final allow = false.obs;
  final current_index = 0.obs;
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  late ConcatenatingAudioSource playlist;
  final RxList<SongModel> songmodel = <SongModel>[].obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> buffer_position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final isplaying = false.obs;
  final Rx<LoopMode> Loopmode = LoopMode.off.obs;
  final isshuffleenabled = false.obs;
  late AnimationController animationController;

  @override
  void onInit() {
    check_permission();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    audioPlayer.positionStream.listen((postion) {
      position.value = postion;
    });

    audioPlayer.bufferedPositionStream.listen((bufpos) {
      buffer_position.value = bufpos;
    });

    audioPlayer.durationStream.listen((durpos) {
      duration.value = durpos!;
    });

    audioPlayer.playerStateStream.listen((playing) {
      isplaying.value = playing.playing;
      play_pause_controller();
    });

    audioPlayer.shuffleModeEnabledStream.listen((enable) {
      isshuffleenabled.value = enable;
    });

    super.onInit();
  }

  Future<void> play_pause_controller() async {
    if (isplaying.value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }



  Future<bool> check_permission() async {
    final permission =
        Platform.isAndroid ? Permission.audio : Permission.storage;
    final status = permission.status;
    allow.value = await status.isGranted;
    if (allow.value) {
      LocalPhoneSong();
    }

    return allow.value;
  }

  Future<void> LocalPhoneSong() async {
    try {
      get_isloading(true);
      noerror();
      final result = await onAudioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: SongSortType.TITLE,
          uriType: UriType.EXTERNAL);
      songmodel.value = result;
    } catch (e) {
      get_error(e.toString());
    } finally {
      get_isloading(false);
    }
  }

  Future<void> local_song_player(SongModel song) async {
    try {
      await audioPlayer.setAudioSource(
          AudioSource.file(
            song.data,
          ),
          initialIndex: 0);
      await audioPlayer.play();
    } catch (e) {
      get_error(e.toString());
    }
  }

  Future<void> playlist_song_loading(
      List<SongModel> song, int startindex) async {
    try {
      playlist = ConcatenatingAudioSource(
          children: song.map((play) {
        return AudioSource.file(play.data);
      }).toList());

      await audioPlayer.setAudioSource(playlist, initialIndex: startindex);

      current_index.value = startindex;

      audioPlayer.currentIndexStream.listen((newIndex) {
        if (newIndex != null) {
          current_index.value = newIndex;
        }
      });

      await audioPlayer.play();
    } catch (e) {
      get_error(e.toString());
    }
  }

  Future<void> contorller_for_song() async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
  }

  Future<void> control_seek(Duration seek) async {
    await audioPlayer.seek(seek);
  }

  Future<void> pre_song() async {
    if (audioPlayer.hasPrevious) {
      await audioPlayer.setLoopMode(LoopMode.off);
      await audioPlayer.seekToPrevious();
      await audioPlayer.setLoopMode(Loopmode.value);
      await audioPlayer.play();
    }
  }

  Future<void> next_song() async {
    if (audioPlayer.hasNext) {
      await audioPlayer.setLoopMode(LoopMode.off);
      await audioPlayer.seekToNext();
      await audioPlayer.setLoopMode(Loopmode.value);
      await audioPlayer.play();
    }
  }

  // this code works if the loopmode on but the shuffle is not works
  // Future<void> pre_song() async {
  //   final previousIndex =current_index.value-1;
  //   if(previousIndex>0){
  //     await audioPlayer.seek(Duration.zero,index: previousIndex);
  //   }
  // }
  // Future<void> next_song() async {
  //   final nextIndex =current_index.value+1;
  //   if(nextIndex<songmodel.length){
  //     await audioPlayer.seek(Duration.zero,index: nextIndex);
  //   }
  // }

  Future<void> repeat_or_one() async {
    if (Loopmode.value == LoopMode.off) {
      Loopmode.value = LoopMode.all;
    } else if (Loopmode.value == LoopMode.all) {
      Loopmode.value = LoopMode.one;
    } else {
      Loopmode.value = LoopMode.off;
    }
    await audioPlayer.setLoopMode(Loopmode.value);
  }

  Future<void> shuffle_mode() async {
    final newvalue = !audioPlayer.shuffleModeEnabled;
    await audioPlayer.setShuffleModeEnabled(newvalue);
    if (newvalue) {
      await audioPlayer.shuffle();
    }
    isshuffleenabled.value = newvalue;
  }

  Future<void> stop_song() async {
    if (audioPlayer.playing) {
      await audioPlayer.stop();
    }
  }

  /// Get current playing song
  SongModel get currentSong => songmodel[current_index.value];
}
