class Artist {
  final int id;
  final String? artistName;
  final String? artistBio;
  final String? artistImage;
  final String? country;

  Artist({
    required this.id,
    this.artistName,
    this.artistBio,
    this.artistImage,
    this.country,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? 0,
      artistName: json['artist_name']?.toString(),
      artistBio: json['artist_bio']?.toString(),
      artistImage: json['artist_image']?.toString(),
      country: json['country']?.toString(),
    );
  }
}
