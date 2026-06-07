import 'package:youtube_music/core/network/Api_Endpoint.dart';
import 'package:youtube_music/core/network/Dio_Client.dart';
import 'package:youtube_music/data/data_module/album_module.dart';

class album_crud{
  final dio = Dio_Private_Client().dio;

  Future<List<Album>> get_app_album_song() async{
    final response = await dio.get(Api_Endpoint.get_album_song);
    final List result = response.data;
    return result.map((album)=>Album.fromJson(album)).toList();
  }

  Future<Album> retrive_album_song(int AlbumId)async{
    final response = await dio.get(Api_Endpoint.get_user_pick_album_song(AlbumId));
    return Album.fromJson(response.data);
  }
}