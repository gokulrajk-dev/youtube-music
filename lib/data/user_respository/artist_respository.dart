import 'package:youtube_music/core/network/Api_Endpoint.dart';
import 'package:youtube_music/core/network/Dio_Client.dart';
import 'package:youtube_music/data/data_module/artist.dart';

class Artist_crud {
  final dio = Dio_Private_Client().dio;

  Future<List<Artist>> get_artist_list() async{
    final response = await dio.get(Api_Endpoint.get_artist);
    final List result = response.data;
    return result.map((artist)=>Artist.fromJson(artist)).toList();
  }

  Future<Artist> get_artist_song(int ArtistId)async{
    final response = await dio.get(Api_Endpoint.get_artist_song(ArtistId));
    return Artist.fromJson(response.data);
  }
}