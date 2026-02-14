import 'package:get/get.dart';
import 'package:youtube_music/core/base/base_controller.dart';
import 'package:youtube_music/data/data_module/playlist.dart';
import 'package:youtube_music/data/user_respository/user_playlist_respository.dart';


class Playlist_Controller extends base_controller{
  final user_playlist_song = Rxn<Playlist>();
  final UserPlaylistCrud userPlaylistCrud = UserPlaylistCrud();



  Future<void> get_user_pick_song_playlist(int pickPlaylistId) async{
    try{
      get_isloading(true);
      noerror();
      user_playlist_song.value = await userPlaylistCrud.retrive_user_playlist(pickPlaylistId);
    }catch(e){
      get_error(e.toString());
    }finally{
      get_isloading(false);
    }
  }

}