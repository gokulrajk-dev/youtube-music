import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:youtube_music/core/base/base_controller.dart';
import 'package:youtube_music/data/data_module/artist.dart';
import 'package:youtube_music/data/user_respository/artist_respository.dart';

class Artist_Controller extends base_controller{
  final RxList<Artist> get_artist = <Artist>[].obs;
  final Artist_crud artist_crud = Artist_crud();
  final retrive_artist = Rxn<Artist>();

  @override
  void onInit() {
    get_full_aritist_list();
    super.onInit();
  }

  Future<void> get_full_aritist_list()async{
    try{
      noerror();
      final result= await artist_crud.get_artist_list();
      get_artist.value =result;
    }catch(e){
      get_error(e.toString());
    }
  }

  Future<void> retrive_artist_with_song(int ArtistId)async{
    try{
      get_isloading(true);
      noerror();
      retrive_artist.value = await artist_crud.get_artist_song(ArtistId);
    }catch(e){
      get_error(e.toString());
    }finally{
      get_isloading(false);
    }
  }
}

