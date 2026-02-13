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

class Song {
  final int id;
  final String title;
  final List<Artist> artist;
  final List<Genre> genre;
  final Album album;
  final String songsFile;
  final String coverImage;
  final String duration;
  final String releaseDate;
  final String lyrics;
  final String language;
  final int views;
  final int likesCount;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.album,
    required this.songsFile,
    required this.coverImage,
    required this.duration,
    required this.releaseDate,
    required this.lyrics,
    required this.language,
    required this.views,
    required this.likesCount,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: (json['artist'] as List)
          .map((e) => Artist.fromJson(e))
          .toList(),
      genre: (json['genre'] as List)
          .map((e) => Genre.fromJson(e))
          .toList(),
      album: Album.fromJson(json['album']),
      songsFile: json['songs_file'],
      coverImage: json['cover_image'],
      duration: json['duration'],
      releaseDate: json['release_date'],
      lyrics: json['lyrics'],
      language: json['language'],
      views: json['views'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
    );
  }
}
