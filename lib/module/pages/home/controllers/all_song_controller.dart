import 'package:get/get.dart';
import 'package:youtube_music/data/user_respository/song_respository.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../data/data_module/song_module.dart';

class get_all_song_controller extends base_controller {
  final Song_Repository song_repository = Song_Repository();

  final RxList<Song> songs = <Song>[].obs;

  @override
  void onInit() {
    get_all_songs();
    super.onInit();
  }

  Future<void> get_all_songs() async {
    try {
      get_isloading(true);
      noerror();
      final result = await song_repository.get_all_song();
      songs.value = result;
    } catch (e) {
      get_error(e.toString());
    } finally {
      get_isloading(false);
    }
  }
}

class get_current_song extends base_controller {
  final Song_Repository song_repository = Song_Repository();
  final current_song = Rxn<Song>();
  final RxList<Song> queue = <Song>[].obs;
  final currentIndex = 0.obs;

  Future<void> setQueue(List<Song> song, int startIndex) async {
    queue.value = song;
    currentIndex.value = startIndex;
    await get_current_user_pick_song(song[currentIndex.value].id);
  }

  Future<void> play_Next() async {
    if (currentIndex.value < queue.length - 1) {
      currentIndex.value++;
      await get_current_user_pick_song(queue[currentIndex.value].id);
    }
  }

  Future<void> play_Previous() async {
    if (currentIndex.value >0) {
      currentIndex.value--;
      await get_current_user_pick_song(queue[currentIndex.value].id);
    }
  }

  Future<void> clear_user() async {
    current_song.value = null;
  }

  Future<void> get_current_user_pick_song(int CurrentSongId) async {
    try {
      get_isloading(true);
      noerror();
      current_song.value =
          await song_repository.retrive_user_pick_song(CurrentSongId);
    } catch (e) {
      get_error(e.toString());
    } finally {
      get_isloading(false);
    }
  }

// todo after the project almost done
// Future<void> update_song_count(int songCount) async{
//
//   current_song.update((like){
//     if(like!=null) {
//       like.likesCount = songCount;
//     }
//   });
// }
}
