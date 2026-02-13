import 'package:youtube_music/core/network/Api_Endpoint.dart';
import 'package:youtube_music/core/network/Dio_Client.dart';
import 'package:youtube_music/data/data_module/like_model.dart';

class like_crud {
  final dio = Dio_Private_Client().dio;

  Future<List<LikeModel>> get_user_liked_songs() async {
    final response = await dio.get(Api_Endpoint.get_like_song);
    final List data = response.data;
    return data.map((like) => LikeModel.fromJson(like)).toList();
  }

  Future<void> post_delete_user_like_song(int songId) async {
    final response = await dio
        .post(Api_Endpoint.post_del_user_like_song, data: {"song_id": songId});
  }
}
