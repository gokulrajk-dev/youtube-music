class Genre {
    final int id;
    final String? genreName;
    final String? description;

    Genre({
        required this.id,
          this.genreName,
          this.description,
    });

    factory Genre.fromJson(Map<String, dynamic> json) {
        return Genre(
            id:json['id'] ?? 0,
            genreName: json['genre_name']?.toString(),
            description: json['description']?.toString(),
        );
    }
}
