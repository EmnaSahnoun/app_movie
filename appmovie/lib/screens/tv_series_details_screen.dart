import 'package:flutter/material.dart';
import '../models/tv_series_details.dart';
import '../services/tv_series_service.dart';
import '../models/actor.dart';
class SeriesDetailsScreen extends StatefulWidget {
  final int seriesId;

  SeriesDetailsScreen({required this.seriesId});

  @override
  _SeriesDetailsScreenState createState() => _SeriesDetailsScreenState();
}

class _SeriesDetailsScreenState extends State<SeriesDetailsScreen> {
  final SeriesService _seriesService = SeriesService();
  late Future<TvSeriesDetails> _seriesDetailsFuture;
  late Future<List<Actor>> _actorsFuture;

  @override
  void initState() {
    super.initState();
    _seriesDetailsFuture = _seriesService.fetchSeriesDetails(widget.seriesId);
   _actorsFuture = _seriesService.fetchSeriesActors(widget.seriesId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: FutureBuilder<TvSeriesDetails>(
        future: _seriesDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No details found.'));
          } else {
            final series = snapshot.data!;
            return _buildSeriesDetails(series);
          }
        },
      ),
    );
  }

  Widget _buildSeriesDetails(TvSeriesDetails series) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none, // Permet à la petite image de dépasser
            children: [
              // Image de fond
              Image.network(
                series.getBackdropUrl(),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Icons.broken_image, size: 50));
                },
              ),
              // Image de l'affiche positionnée précisément
              Positioned(
                bottom: -50,
                left: 16,
                child: Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      series.getPosterUrl(),
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
          SizedBox(height: 60), // Espace pour compenser le chevauchement
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre de la série
                Text(
                  series.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                // Année de première diffusion et nombre d'épisodes
                Text(
                  '${_getFirstAirYear(series.firstAirDate)} • ${series.numberOfEpisodes ?? 'N/A'} episodes',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 8),
                // Badge IMDb
                Row(
                  children: [
                    _buildIMDBBadge(series.voteAverage),
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
                // Section "À propos de la série"
                Text(
                  'About the series',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  series.overview ?? 'No description available.',
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
                    _platformButton('Hulu', Colors.blue),
                    _platformButton('Disney+', Colors.purple),
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

  String _getFirstAirYear(String? firstAirDate) {
    if (firstAirDate == null) return 'Unknown';
    try {
      final date = DateTime.parse(firstAirDate);
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
