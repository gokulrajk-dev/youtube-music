import 'package:get/get.dart';
import 'package:youtube_music/core/base/base_controller.dart';
import 'package:youtube_music/data/data_module/like_model.dart';

import '../../../../data/user_respository/user_like_repository.dart';
import '../../../data/data_module/song_module.dart';
import '../../../services/helper_code/helper_code.dart';
import '../home/controllers/all_song_controller.dart';

// todo after complete the app like need optimization.
class Like_Controller extends base_controller {
  final RxList<LikeModel> like_song = <LikeModel>[].obs;
  final like_crud likecrud = like_crud();

  final get_current_song current_song = Get.find<get_current_song>();

  @override
  void onInit() async {
    await get_current_user_like_songs();
    super.onInit();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   get_current_user_like_songs();
  // }

  Future<void> get_current_user_like_songs() async {
    try {
      get_isloading(true);
      noerror();
      final result = await likecrud.get_user_liked_songs();
      like_song.value = result;
    } catch (e) {
      get_error(e.toString());
    } finally {
      get_isloading(false);
    }
  }

  void clear_like() {
    like_song.value = [];
  }

  bool get_song_like_or_not(int songId) {
    return like_song.any((e) => e.song?.id == songId);
  }

  Future<void> post_del_user_like(Song song) async {
    await likecrud.post_delete_user_like_song(song.id);
    final unlike = get_song_like_or_not(song.id);
    print("true or false: $unlike");
    if (unlike == true) {
      int index =
          like_song.indexWhere((element) => element.song!.id == song.id);
      like_song.removeAt(index);
      like_song.refresh();
      current_song.current_song.value?.likesCount =
          (current_song.current_song.value?.likesCount ?? 1) - 1;
      showGlobalMessage(
          "Remove from liked music ");
    } else {
      like_song.insert(0, LikeModel(song: song));
      current_song.current_song.value?.likesCount =
          (current_song.current_song.value?.likesCount ?? 0) + 1;
      showGlobalMessage(
          "Saved to liked music ","like");
    }

  }
}
