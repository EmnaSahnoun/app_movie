class TvSeriesDetails {
  final String name;
  final String? posterPath;
  final String? backdropPath; // Nouveau champ ajouté
  final String? firstAirDate;
  final double? voteAverage;
  final int? voteCount;
  final String? overview;
  final int? numberOfEpisodes; // Nouveau champ ajouté

  TvSeriesDetails({
    required this.name,
    this.posterPath,
    this.backdropPath, // Ajout dans le constructeur
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
    this.overview,
    this.numberOfEpisodes, // Ajout dans le constructeur
  });

  factory TvSeriesDetails.fromJson(Map<String, dynamic> json) {
    return TvSeriesDetails(
      name: json['name'] ?? 'Untitled',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'], // Récupérer le champ depuis l'API
      firstAirDate: json['first_air_date'],
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'],
      overview: json['overview'],
      numberOfEpisodes: json['number_of_episodes'], // Récupérer le champ depuis l'API
    );
  }

  // Méthode pour obtenir l'URL de l'affiche
  String getPosterUrl() {
    if (posterPath == null) {
      return 'https://via.placeholder.com/500x750?text=No+Image';
    }
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  // Méthode pour obtenir l'URL de l'image de fond (backdrop)
  String getBackdropUrl() {
    if (backdropPath == null) {
      return 'https://via.placeholder.com/500x281?text=No+Backdrop';
    }
    return 'https://image.tmdb.org/t/p/w500$backdropPath';
  }
}
