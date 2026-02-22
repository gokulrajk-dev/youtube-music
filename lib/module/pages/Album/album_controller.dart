import 'package:get/get.dart';
import 'package:youtube_music/core/base/base_controller.dart';
import 'package:youtube_music/data/data_module/album_module.dart';
import 'package:youtube_music/data/user_respository/album_respository.dart';

class Album_Controller extends base_controller {
  final RxList<Album> album_song = <Album>[].obs;
  final album_crud album_cru = album_crud();
  final retrive_album_song = Rxn<Album>();

  @override
  void onInit() {
    get_song_album();
    super.onInit();
  }

  Future<void> get_song_album() async{
    try{
      noerror();
      final result = await album_cru.get_app_album_song();
      album_song.value=result;
    }catch(e){
      get_error(e.toString());
    }
  }
  Future<void> retrive_album_song_con(int AlbumId)async{
    try{
      get_isloading(true);
      noerror();
      retrive_album_song.value = await album_cru.retrive_album_song(AlbumId);
    }catch(e){
      get_error(e.toString());
    }finally{
      get_isloading(false);
    }
  }
}

