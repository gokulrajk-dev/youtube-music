import 'package:youtube_music/data/data_module/song_module.dart';

class Artist {
  final int id;
  final String? artistName;
  final String? artistBio;
  final String? artistImage;
  final String? country;
  final List<Song>? SongArtist;

  Artist({
    required this.id,
    this.artistName,
    this.artistBio,
    this.artistImage,
    this.country,
    this.SongArtist
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? 0,
      artistName: json['artist_name']?.toString(),
      artistBio: json['artist_bio']?.toString(),
      artistImage: json['artist_image']?.toString(),
      country: json['country']?.toString(),
      SongArtist: (json['songs_artist'] as List?)?.map((artsong)=>Song.fromJson(artsong)).toList(),
    );
  }
}
