import 'package:dio/dio.dart';
import 'package:youtube_music/core/network/Api_Endpoint.dart';
import 'package:youtube_music/core/network/Dio_Client.dart';
import 'package:youtube_music/data/data_module/playlist.dart';

class UserPlaylistCrud {
  final dio = Dio_Private_Client().dio;

  Future<List<Playlist>> Get_user_playlist() async {
    final response = await dio.get(Api_Endpoint.get_current_user_playlist);
    List result = response.data;
    return result.map((playlists) => Playlist.fromJson(playlists)).toList();
  }

  Future<Playlist> retrieveUserPlaylist(int pickPlaylistId) async {
    final response = await dio
        .get(Api_Endpoint.get_current_user_pic_playlist(pickPlaylistId));
    return Playlist.fromJson(response.data);
  }

  Future<Response?> createUserPlaylist(
      String playListName, String description, bool isPublic,List<int> songId) async {
    try {
      final response = await dio.post(Api_Endpoint.get_current_user_playlist, data: {
        "playlist_name": playListName,
        "description": description,
        "is_public": isPublic,
        "songs_id":songId
      });
      print("$response");
      return response;

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<int?> deleteUserPlaylist(int playlistId)async{
    try {
      final status = await dio.delete(
          Api_Endpoint.get_current_user_pic_playlist(playlistId));
      return status.statusCode;
    }
    catch(_){
    }
    return null;
  }

  Future<int?> songsAddedPlaylist(int playlistId,List<int> songId) async{
    try{
      final status = await dio.post(Api_Endpoint.get_current_user_pic_playlist(playlistId),
        data: {
          "songs_id":songId
        }
      );
      return status.statusCode;
    }catch(_){
    }
    return null;
  }

}
