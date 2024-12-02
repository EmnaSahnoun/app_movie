class Actor {
  final int id;
  final String name;
  final String? profilePath;
  final String? character;

  Actor({
    required this.id,
    required this.name,
    this.profilePath,
    this.character,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'] as int,
      name: json['name'] as String,
      profilePath: json['profile_path'] as String?,
      character: json['character'] as String?,
    );
  }

  String getProfileUrl() {
    return profilePath != null
        ? 'https://image.tmdb.org/t/p/w500$profilePath'
        : 'https://via.placeholder.com/150?text=No+Image';
  }
}
