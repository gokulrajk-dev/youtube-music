import 'artist.dart';

class Album {
  final int id;
  final String? title;
  final String? coverImage;
  final String? releaseDate;
  final String? description;
  final List<Artist>? artists;

  Album({
    required this.id,
    this.title,
    this.coverImage,
    this.releaseDate,
    this.description,
    this.artists,
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
    );
  }
}
