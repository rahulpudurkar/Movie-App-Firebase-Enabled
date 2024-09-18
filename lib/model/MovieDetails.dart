class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String backdropPath;
  final String posterPath;
  final List<Genre> genres;
  final double popularity;
  final double voteAverage;
  final DateTime releaseDate; 

  MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.backdropPath,
    required this.posterPath,
    required this.genres,
    required this.popularity,
    required this.voteAverage,
    required this.releaseDate, 
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      genres: (json['genres'] as List)
          .map((genreJson) => Genre.fromJson(genreJson))
          .toList(),
      popularity: json['popularity'],
      voteAverage: json['vote_average'].toDouble(),
      releaseDate: DateTime.parse(json['release_date']), 
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}
