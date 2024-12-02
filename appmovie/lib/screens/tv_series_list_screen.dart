import 'package:flutter/material.dart';
import 'tv_series_grid_view.dart'; // Un widget réutilisable pour afficher une grille de séries

class SeriesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: TvSeriesGridView(type: 'popular'), // Grille des séries populaires
    );
  }
}
