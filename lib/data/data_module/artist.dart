class Artist {
  final int id;
  final String artistName;
  final String artistBio;
  final String? artistImage;
  final String country;

  Artist({
    required this.id,
    required this.artistName,
    required this.artistBio,
    this.artistImage,
    required this.country,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      artistName: json['artist_name'],
      artistBio: json['artist_bio'],
      artistImage: json['artist_image'],
      country: json['country'],
    );
  }
}
