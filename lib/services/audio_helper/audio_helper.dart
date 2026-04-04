import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_music/data/data_module/song_module.dart';


class MyAudioController extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  /// ✅ EXPOSE STREAMS (FIXES YOUR ERROR)
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// ✅ EXPOSE PLAYING STATE
  bool get playing => _player.playing;

  MyAudioController() {
    _listen();
  }

  void _listen() {
    _player.playerStateStream.listen((state) {
      playbackState.add(playbackState.value.copyWith(
          playing: state.playing,
          processingState: _mapState(state.processingState),
          controls: [
            MediaControl.skipToPrevious,
            state.playing ? MediaControl.pause : MediaControl.play,
            MediaControl.skipToNext,
          ]));
    });
  }

  AudioProcessingState _mapState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  Future<void> playSong(String url, Song song) async {
    await _player.setUrl(url);

    mediaItem.add(
      MediaItem(
        id: url,
        title: song.title ?? "Unknown",
        artist: song.artist!.map((e) => e.artistName).join(''),
        album: "${song.album}",
      ),
    );
    await _player.play();
  }
  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

}
