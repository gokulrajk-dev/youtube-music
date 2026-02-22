import 'package:get/get.dart';
import 'package:youtube_music/core/base/base_controller.dart';
import 'package:youtube_music/data/data_module/user_history.dart';
import 'package:youtube_music/data/user_respository/user_history_respository.dart';

class Histroy_Controller extends base_controller{
  final RxList<UserHistory> history = <UserHistory>[].obs;
  final UserHistoryCrud historyCrud = UserHistoryCrud();

  @override
  void onInit() {
    get_current_song_history();
    super.onInit();
  }

  // @override
  // void onReady() {
  //   get_current_song_history();
  //   super.onReady();
  // }

  Future<void> get_current_song_history() async{
    try{
      get_isloading(true);
      noerror();
      history.value = await historyCrud.get_user_song_history();
    }catch(e){
      get_error(e.toString());
    }finally{
      get_isloading(false);
    }
  }
}