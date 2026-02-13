

import 'package:youtube_music/core/network/Dio_Client.dart';

import '../../core/network/Api_Endpoint.dart';
import '../data_module/song_module.dart';

class Song_Repository{
  final dio=Dio_Private_Client().dio;

  Future<List<Song>> get_all_song() async{
    final response = await dio.get(Api_Endpoint.get_song);
    print('RAW RESPONSE: ${response.data}');
    print('TYPE: ${response.data.runtimeType}');
    final List data = response.data;
    return data.map((e)=>Song.fromJson(e)).toList();
  }

  Future<Song> retrive_user_pick_song(int CurrentSongId) async{
    final response = await dio.get(Api_Endpoint.get_modity_current_song_id(CurrentSongId));
    return Song.fromJson(response.data);
  }
}