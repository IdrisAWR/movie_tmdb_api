class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  // Factory method untuk mengubah JSON Object menjadi Objek Movie 
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      overview: json['overview'] ?? 'No Description',
      // Poster path kadang null, kita handle string kosongnya
      posterPath: json['poster_path'] ?? '', 
      backdropPath: json['backdrop_path'] ?? '',
      // Konversi ke double karena rating bisa berupa integer atau desimal
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? 'Unknown',
    );
  }
}