import 'package:flutter/material.dart';
import 'movie_list_screen.dart'; // Écran des films
import 'tv_series_list_screen.dart'; // Écran des séries

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Liste des écrans pour chaque onglet
  final List<Widget> _screens = [
    MoviesAndSeriesTabScreen(), // Écran principal avec les onglets Films/Séries
    Center(child: Text('Find Screen')), // Placeholder pour "Find"
    Center(child: Text('Feed Screen')), // Placeholder pour "Feed"
    Center(child: Text('Watched List Screen')), // Placeholder pour "Watched List"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Affiche l'écran correspondant à l'onglet sélectionné
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Couleur de fond blanche
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Ombre légère
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue[900], // Couleur de l'icône sélectionnée (bleu foncé)
          unselectedItemColor: Colors.grey, // Couleur des icônes non sélectionnées
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Find',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(Icons.favorite_outline),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              label: 'Watched List',
            ),
          ],
        ),
      ),
    );
  }
}

class MoviesAndSeriesTabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Deux onglets : Films et Séries
      child: Scaffold(
        appBar: AppBar(
          title: Text('Movies & TV Series'),
          bottom: TabBar(
            indicatorColor: Colors.amber, // Couleur de l'indicateur d'onglet
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'Series'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MovieListScreen(), // Liste des films
            SeriesListScreen(), // Liste des séries
          ],
        ),
      ),
    );
  }
}
