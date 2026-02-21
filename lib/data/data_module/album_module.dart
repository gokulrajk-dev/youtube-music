import 'package:youtube_music/data/data_module/song_module.dart';

import 'artist.dart';

class Album {
  final int id;
  final String? title;
  final String? coverImage;
  final String? releaseDate;
  final String? description;
  final List<Artist>? artists;
  final List<Song>? songAlbum;

  Album({
    required this.id,
    this.title,
    this.coverImage,
    this.releaseDate,
    this.description,
    this.artists,
    this.songAlbum
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] ?? 0,
      title: json['title']?.toString(),
      coverImage: json['cover_image']?.toString(),
      releaseDate: json['release_date']?.toString(),
      description: json['description']?.toString(),
      artists: (json['artists'] as List?)
          ?.map((e) => Artist.fromJson(e))
          .toList(),
      songAlbum: (json['song_album'] as List?)?.map((song)=>Song.fromJson(song)).toList(),
    );
  }
}
