// // To parse this JSON data, do
// //
// //     final song = songFromJson(jsonString);
//
// import 'dart:convert';
//
// import 'album_module.dart';
// import 'artist.dart';
// import 'genre.dart';
//
// Song songFromJson(String str) => Song.fromJson(json.decode(str));
//
// String songToJson(Song data) => json.encode(data.toJson());
//
// class Song {
//   int id;
//   String title;
//   List<Artist> artist;
//   List<Genre> genre;
//   Album album;
//   String songsFile;
//   String coverImage;
//   String duration;
//   DateTime releaseDate;
//   String lyrics;
//   String language;
//   int views;
//   int likesCount;
//
//   Song({
//     required this.id,
//     required this.title,
//     required this.artist,
//     required this.genre,
//     required this.album,
//     required this.songsFile,
//     required this.coverImage,
//     required this.duration,
//     required this.releaseDate,
//     required this.lyrics,
//     required this.language,
//     required this.views,
//     required this.likesCount,
//   });
//
//   factory Song.fromJson(Map<String, dynamic> json) => Song(
//     id: json["id"],
//     title: json["title"],
//     artist: List<Artist>.from(json["artist"].map((x) => Artist.fromJson(x))),
//     genre: List<Genre>.from(json["genre"].map((x) => Genre.fromJson(x))),
//     album: Album.fromJson(json["album"]),
//     songsFile: json["songs_file"],
//     coverImage: json["cover_image"],
//     duration: json["duration"],
//     releaseDate: DateTime.parse(json["release_date"]),
//     lyrics: json["lyrics"],
//     language: json["language"],
//     views: json["views"],
//     likesCount: json["likes_count"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "title": title,
//     "artist": List<dynamic>.from(artist.map((x) => x.toJson())),
//     "genre": List<dynamic>.from(genre.map((x) => x.toJson())),
//     "album": album.toJson(),
//     "songs_file": songsFile,
//     "cover_image": coverImage,
//     "duration": duration,
//     "release_date": releaseDate.toIso8601String(),
//     "lyrics": lyrics,
//     "language": language,
//     "views": views,
//     "likes_count": likesCount,
//   };
// }



import 'album_module.dart';
import 'artist.dart';
import 'genre.dart';

class Song  {

  // @override
  // String? get song_title => title;
  //
  // @override
  // // TODO: implement song_id
  // int get song_id => id;
  //
  //
  // @override
  // String? get subtitle => artist?.map((e) => e.artistName).join(',');
  //
  // @override
  // String? get image => coverImage;


  final int id;
  final String? title;
  final List<Artist>? artist;
  final List<Genre>? genre;
  final Album? album;
  final String? songsFile;
  final String? coverImage;
  final Duration? duration;
  final String? releaseDate;
  final String? lyrics;
  final String? language;
  final int views;
  final int likesCount;

  Song({
    required this.id,
    this.title,
    this.artist,
    this.genre,
    this.album,
    this.songsFile,
    this.coverImage,
    this.duration,
    this.releaseDate,
    this.lyrics,
    this.language,
    required this.views,
    required this.likesCount,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title']?.toString(),
      artist:
          (json['artist'] as List?)?.map((e) => Artist.fromJson(e)).toList(),
      genre: (json['genre'] as List?)?.map((e) => Genre.fromJson(e)).toList(),
      album: json['album'] != null ? Album.fromJson(json['album']) : null,
      songsFile: json['songs_file']?.toString(),
      coverImage: json['cover_image']?.toString(),
      duration: json['duration']!=null? _parseDuration(json['duration']):null,
      releaseDate: json['release_date']?.toString(),
      lyrics: json['lyrics']?.toString(),
      language: json['language']?.toString(),
      views: json['views'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
    );
  }

  static Duration _parseDuration(String duration){
    final part  = duration.split(':');
    return Duration(
      hours: int.parse(part[0]),
      minutes: int.parse(part[1]),
      seconds: int.parse(part[2])
    );
  }


}
