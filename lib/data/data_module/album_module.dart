import 'artist.dart';

class Album {
  final int id;
  final String title;
  final String coverImage;
  final String releaseDate;
  final String description;
  final List<Artist> artists;

  Album({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.releaseDate,
    required this.description,
    required this.artists,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
      coverImage: json['cover_image'],
      releaseDate: json['release_date'],
      description: json['description'],
      artists: (json['artists'] as List)
          .map((e) => Artist.fromJson(e))
          .toList(),
    );
  }
}
