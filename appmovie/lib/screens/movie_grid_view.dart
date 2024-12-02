import 'package:flutter/material.dart';
import '../models/movie_preview.dart';
import '../services/movie_service.dart';
import 'movie_details_screen.dart';

class MovieGridView extends StatefulWidget {
  final String type;
  final String searchQuery; // Nouvelle propriété pour la recherche

  MovieGridView({required this.type, required this.searchQuery});

  @override
  _MovieGridViewState createState() => _MovieGridViewState();
}

class _MovieGridViewState extends State<MovieGridView> {
  final MovieService _movieService = MovieService();
  late Future<List<MoviePreview>> _moviesFuture;
  List<MoviePreview> _movies = [];
  List<MoviePreview> _filteredMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() {
    _moviesFuture = _movieService.fetchMovies(widget.type);
    _moviesFuture.then((movies) {
      setState(() {
        _movies = movies;
        _filterMovies(widget.searchQuery); // Filtrage initial
      });
    });
  }

  @override
  void didUpdateWidget(MovieGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _filterMovies(widget.searchQuery);
    }
  }

  void _filterMovies(String query) {
    setState(() {
      _filteredMovies = _movies
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MoviePreview>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun film trouvé.'));
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: _filteredMovies.length,
            itemBuilder: (context, index) {
              final movie = _filteredMovies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailsScreen(movieId: movie.id),
                    ),
                  );
                },
                child: MovieCard(movie: movie),
              );
            },
          );
        }
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  final MoviePreview movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              movie.getPosterUrl(),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Icon(Icons.broken_image, size: 50));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie.title,
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
