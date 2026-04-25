import 'package:get/get.dart';
import 'package:youtube_music/data/user_respository/song_respository.dart';
import 'package:youtube_music/route/app_route.dart';
import 'package:youtube_music/services/helper_code/helper_code.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../data/data_module/song_module.dart';

class get_all_song_controller extends base_controller {
  final Song_Repository song_repository = Song_Repository();
  final RxList<Song> songs = <Song>[].obs;

  @override
  void onInit() async {
    await get_all_songs();
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
  final RxList<Song> copyqueue = <Song>[].obs;
  final currentIndex = 0.obs;
  final isshuffleenabled = false.obs;
  final isReordering = false.obs;

  Future<void> setQueue(List<Song> song, int startIndex) async {
    queue.assignAll(song);
    currentIndex.value = startIndex;
    await get_current_user_pick_song(song[currentIndex.value].id);
  }

  void autoSongType(dynamic song, int Index) async {
    if (song is Song) {
      setQueue([song], Index);
    } else if (song is List<Song>) {
      setQueue(song, Index);
    }
  }

  Future<void> play_Next() async {
    if (currentIndex.value < queue.length - 1) {
      currentIndex.value++;
      get_current_user_pick_song(queue[currentIndex.value].id);
    }
  }


  Future<void> play_Previous() async {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      get_current_user_pick_song(queue[currentIndex.value].id);
    }
  }

  Future<void> playNext(List<Song> song, int index) async {
    if (queue.isEmpty) {
      autoSongType(song, 0);
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.toNamed(App_route.full_screen_media_player_page);
      });
      return;
    }
    ;

    // 🔵 CASE 1: From queue
    if (index != -1) {
      // remove that exact item
      if (index != currentIndex.value) {
        final item = queue.removeAt(index);

        if (index < currentIndex.value) {
          currentIndex.value--;
        }
        // insert next
        queue.insert(currentIndex.value + 1, item);
        queue.refresh();
        return;
      }
    }

    queue.insertAll(currentIndex.value + 1, song);
    queue.refresh();

    showGlobalMessage("${song.first.title} will play next");
  }

  void autoplayNextDataType(dynamic songId, int index) {
    if (songId is Song) {
      playNext([songId], index);
    } else if (songId is List<Song>) {
      playNext(songId, index);
    }
  }

  void dismissQueue(int index) async {
    if (queue.length == 1) {
      Get.back();
      clear_user();
      Get.back();
      queue.value = [];
      return;
    }
    if (index == currentIndex.value && index != -1) {
      try {
        isReordering.value = false;
        await play_Next();
      } finally {
        isReordering.value = true;
      }
    }

    queue.removeAt(index);

    if (index < currentIndex.value) {
      currentIndex.value--;
    }
    queue.refresh();
  }

  void AddToQueue(dynamic song) {
    if (song is Song) {
      queue.add(song);
      showGlobalMessage("${song.title} Added to Queue");
    } else if (song is List<Song>) {
      queue.addAll(song);
      showGlobalMessage("Songs Added to Queue");
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

  Future<void> selectFromQueue(int index) async {
    try {
      isReordering.value = false;
      await setQueue(queue.toList(), index);
    } finally {
      isReordering.value = true;
    }
  }

  void shuffle_on_off() {
    isshuffleenabled.value = !isshuffleenabled.value;
    if (isshuffleenabled.value) {
      copyqueue.assignAll(queue);
      queue.shuffle();
      queue.refresh();
    } else {
      queue.assignAll(copyqueue);
      queue.refresh();
    }
    int currentSong =
        queue.indexWhere((song) => song.id == current_song.value!.id);
    currentIndex.value = currentSong;
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
