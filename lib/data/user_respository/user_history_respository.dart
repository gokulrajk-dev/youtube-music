import 'package:youtube_music/core/network/Api_Endpoint.dart';
import 'package:youtube_music/core/network/Dio_Client.dart';


class UserHistoryCrud {
  final dio = Dio_Private_Client().dio;

  Future<Map<String, dynamic>> get_user_song_history(int page)async{
    final response = await dio.get(Api_Endpoint.get_current_user_history(page));
    return response.data;
  }

  Future<void> post_user_song_histroy(int songId,int Song_Duration) async{
    await dio.post(Api_Endpoint.post_histroy,data: {
      "songs_id":songId,
      "duration":Song_Duration
    });
  }

}