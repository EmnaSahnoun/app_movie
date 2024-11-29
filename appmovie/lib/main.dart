import 'package:flutter/material.dart';
import 'screens/movie_list_screen.dart'; // la liste des films
import 'screens/movie_details_screen.dart'; //  détails d'un film
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Movie App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.amber, // Définit l'équivalent d'accentColor
        ),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MovieListScreen(), // À implémenter
        '/details': (context) => MovieDetailsScreen(movieId: 0), // À implémenter
      },
    );
  }
}
