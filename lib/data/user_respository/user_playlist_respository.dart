import 'package:youtube_music/core/network/Api_Endpoint.dart';
import 'package:youtube_music/core/network/Dio_Client.dart';
import 'package:youtube_music/data/data_module/playlist.dart';

class UserPlaylistCrud{
  final dio = Dio_Private_Client().dio;
  
  Future<List<Playlist>> Get_user_playlist() async{
    final response = await dio.get(Api_Endpoint.get_current_user_playlist);
    List result = response.data;
    return result.map((playlists)=>Playlist.fromJson(playlists)).toList();
  }

  Future<Playlist> retrive_user_playlist(int pickPlaylistId) async{
    final response = await dio.get(Api_Endpoint.get_current_user_pic_playlist(pickPlaylistId));
    return Playlist.fromJson(response.data);
  }

} 