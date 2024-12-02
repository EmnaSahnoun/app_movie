class SeriesPreview {
  final int id;
  final String name; // Nom de la série
  final String? posterPath;

  SeriesPreview({
    required this.id,
    required this.name,
    this.posterPath,
  });

  factory SeriesPreview.fromJson(Map<String, dynamic> json) {
    return SeriesPreview(
      id: json['id'],
      name: json['name'] ?? 'Untitled', // Utilise "name" pour les séries
      posterPath: json['poster_path'], // Peut être null
    );
  }

  String getPosterUrl() {
    if (posterPath == null) {
      return 'https://via.placeholder.com/500x750?text=No+Image';
    }
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
}
