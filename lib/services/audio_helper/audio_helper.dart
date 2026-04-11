import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_music/data/data_module/song_module.dart';
import 'package:youtube_music/module/pages/home/controllers/all_song_controller.dart';

class MyAudioController extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final get_current_song song =
      Get.put<get_current_song>(get_current_song(), permanent: true);

  /// ✅ EXPOSE STREAMS (FIXES YOUR ERROR)
  Stream<Duration> get positionStream => _player.positionStream;

  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;

  Stream<Duration?> get durationStream => _player.durationStream;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// ✅ EXPOSE PLAYING STATE
  bool get playing => _player.playing;

  MyAudioController() {
    _init();
    _listen();
  }

  Future<void> _init() async {
    await _player.setAutomaticallyWaitsToMinimizeStalling(true);
  }

  void _listen() {
    _player.playerStateStream.listen((state) async {
      playbackState.add(playbackState.value.copyWith(
          playing: state.playing,

          processingState: _mapState(state.processingState),
          controls: [
            MediaControl.skipToPrevious,
            state.playing ? MediaControl.pause : MediaControl.play,
            MediaControl.skipToNext,
          ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
      ));

      if (state.processingState == ProcessingState.completed) {
        await skipToNext();
      }
    });

    _player.positionStream.listen((position) {
      playbackState.add(
        playbackState.value.copyWith(
          updatePosition: position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
        ),
      );
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
        artist: song.artist!.map((e) => e.artistName).join(','),
        album: " Album : ${song.album!.title}",
        duration: song.duration,
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

  @override
  Future<void> skipToPrevious() async {
    await song.play_Previous();
  }

  @override
  Future<void> skipToNext() async {
    await song.play_Next();
  }
}
