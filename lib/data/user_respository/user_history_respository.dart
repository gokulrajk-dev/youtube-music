import 'package:youtube_music/core/network/Api_Endpoint.dart';
import 'package:youtube_music/core/network/Dio_Client.dart';
import 'package:youtube_music/data/data_module/user_history.dart';

class UserHistoryCrud {
  final dio = Dio_Private_Client().dio;

  Future<List<UserHistory>> get_user_song_history()async{
    final response = await dio.get(Api_Endpoint.get_current_user_history);
    final List result = response.data;
    return result.map((history)=>UserHistory.fromJson(history)).toList();
  }

}