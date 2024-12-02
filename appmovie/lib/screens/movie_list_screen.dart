import 'package:flutter/material.dart';
import 'movie_grid_view.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  String _searchQuery = ""; // Stocke la requête de recherche

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query; // Met à jour la requête de recherche
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(onSearch: _onSearchChanged),
          ),
          Expanded(
            child: MovieGridView(
              type: 'movies',
              searchQuery: _searchQuery, // Passe la requête au GridView
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const SearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearch, // Appelle la fonction lorsqu'on tape dans le champ
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search Movie',
        suffixIcon: Icon(Icons.tune),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
