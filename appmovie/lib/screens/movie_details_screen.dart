import 'package:flutter/material.dart';
import '../models/movie_details.dart';
import '../models/actor.dart';
import '../services/movie_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  MovieDetailsScreen({required this.movieId});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final MovieService _movieService = MovieService();
  late Future<MovieDetails> _movieDetailsFuture;
  late Future<List<Actor>> _actorsFuture;

  @override
  void initState() {
    super.initState();
    _movieDetailsFuture = _movieService.fetchMovieDetails(widget.movieId);
    _actorsFuture = _movieService.fetchMovieActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: FutureBuilder<MovieDetails>(
        future: _movieDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No details found.'));
          } else {
            final movie = snapshot.data!;
            return _buildMovieDetails(movie);
          }
        },
      ),
    );
  }

  Widget _buildMovieDetails(MovieDetails movie) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.network(
                movie.getBackdropUrl(),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Icons.broken_image, size: 50));
                },
              ),
              Positioned(
                bottom: -50,
                left: 16,
                child: Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      movie.getPosterUrl(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Icons.broken_image, size: 50));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '${_getReleaseYear(movie.releaseDate)} • ${movie.runtime != null ? movie.getFormattedRuntime() : 'N/A'}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildIMDBBadge(movie.voteAverage),
                    SizedBox(width: 16),
                    Icon(Icons.favorite, color: Colors.red),
                    Text(' 2 likes'),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _actionButton('Save', Icons.bookmark),
                    _actionButton('Rate', Icons.star),
                    _actionButton('+ Lists', Icons.list),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    'Already Seen',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'About the movie',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  movie.overview ?? 'No description available.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Available on:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _platformButton('Netflix', Colors.red),
                    _platformButton('Hotstar', Colors.blue),
                    _platformButton('YouTube', Colors.redAccent),
                  ],
                ),
                SizedBox(height: 16),
                // Display Cast (Actors Carousel)
                Text(
                  'Cast',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                FutureBuilder<List<Actor>>(
                  future: _actorsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No actors found.'));
                    } else {
                      return _buildActorsCarousel(snapshot.data!);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIMDBBadge(double? rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            'IMDb',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 4),
          Text('${rating?.toStringAsFixed(1) ?? 'N/A'}/10'),
        ],
      ),
    );
  }

  Widget _platformButton(String platform, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        label: Text(platform),
        backgroundColor: color,
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _actionButton(String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  String _getReleaseYear(String? releaseDate) {
    if (releaseDate == null) return 'Unknown';
    try {
      final date = DateTime.parse(releaseDate);
      return date.year.toString();
    } catch (e) {
      return 'Unknown';
    }
  }

  Widget _buildActorsCarousel(List<Actor> actors) {
    return SizedBox(
      height: 200, // Height of the carousel
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    actor.getProfileUrl(),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: 100);
                    },
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  actor.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
