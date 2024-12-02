import 'package:flutter/material.dart';
import '../models/tv_series_preview.dart';
import '../services/tv_series_service.dart';
import 'tv_series_details_screen.dart'; // Écran pour les détails d'une série

class TvSeriesGridView extends StatefulWidget {
  final String type; // Exemple : "popular", "top_rated", etc.

  TvSeriesGridView({required this.type});

  @override
  _TvSeriesGridViewState createState() => _TvSeriesGridViewState();
}

class _TvSeriesGridViewState extends State<TvSeriesGridView> {
  final SeriesService _seriesService = SeriesService();
  late Future<List<SeriesPreview>> _seriesFuture;

  @override
  void initState() {
    super.initState();
    _seriesFuture = _seriesService.fetchSeries(widget.type); // Appel API pour les séries
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SeriesPreview>>(
      future: _seriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No TV series found.'));
        } else {
          final series = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: series.length,
            itemBuilder: (context, index) {
              final serie = series[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeriesDetailsScreen(seriesId: serie.id),
                    ),
                  );
                },
                child: TvSeriesCard(series: serie),
              );
            },
          );
        }
      },
    );
  }
}

class TvSeriesCard extends StatelessWidget {
  final SeriesPreview series;

  TvSeriesCard({required this.series});

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
              series.getPosterUrl(),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Icon(Icons.broken_image, size: 50));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              series.name,
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
