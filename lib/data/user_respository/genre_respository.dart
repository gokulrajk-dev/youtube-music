import 'package:youtube_music/data/data_module/genre.dart';

import '../../core/network/Api_Endpoint.dart';
import '../../core/network/Dio_Client.dart';

class Genre_crud {
  final dio = Dio_Private_Client().dio;

  Future<List<Genre>> get_genre_list() async{
    final response = await dio.get(Api_Endpoint.get_genre);
    final List result = response.data;
    return result.map((genre)=>Genre.fromJson(genre)).toList();
  }

  // Future<Artist> get_artist_song(int ArtistId)async{
  //   final response = await dio.get(Api_Endpoint.get_artist_song(ArtistId));
  //   return Artist.fromJson(response.data);
  // }
  //
  // Future<List<Artist>> search_get_artist_list(String searchArtist) async{
  //   final response = await dio.get(Api_Endpoint.search_artist(searchArtist));
  //   final List result = response.data;
  //   return result.map((artist)=>Artist.fromJson(artist)).toList();
  // }

}