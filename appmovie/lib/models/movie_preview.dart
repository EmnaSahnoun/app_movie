class MoviePreview {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final String? releaseDate;

  MoviePreview({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.releaseDate,
  });

  factory MoviePreview.fromJson(Map<String, dynamic> json) {
    return MoviePreview(
      id: json['id'] as int,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      releaseDate: json['release_date'] as String?,
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
}
