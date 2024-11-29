class MovieDetails {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final int? voteCount;
  final String? releaseDate;
  final int? runtime;
  final int? budget;
  final int? revenue;
  final List<Genre> genres;

  MovieDetails({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.voteCount,
    this.releaseDate,
    this.runtime,
    this.budget,
    this.revenue,
    required this.genres,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      releaseDate: json['release_date'] as String?,
      runtime: json['runtime'] as int?,
      budget: json['budget'] as int?,
      revenue: json['revenue'] as int?,
      genres: (json['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
    );
  }

  String getPosterUrl() {
    return posterPath != null
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : 'https://via.placeholder.com/500x750?text=No+Image';
  }

  String getBackdropUrl() {
    return backdropPath != null
        ? 'https://image.tmdb.org/t/p/w780$backdropPath'
        : 'https://via.placeholder.com/780x439?text=No+Image';
  }

  String getFormattedRuntime() {
    if (runtime == null) return 'Unknown';
    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;
    return '${hours}h ${minutes}m';
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
