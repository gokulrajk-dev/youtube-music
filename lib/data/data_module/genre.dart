class Genre {
    final String genreName;
    final String description;

    Genre({
        required this.genreName,
        required this.description,
    });

    factory Genre.fromJson(Map<String, dynamic> json) {
        return Genre(
            genreName: json['genre_name'],
            description: json['description'],
        );
    }
}
