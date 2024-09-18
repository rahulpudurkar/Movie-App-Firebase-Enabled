import 'package:flutter/material.dart';
import 'package:movielist/model/userFavorites.dart';
import 'package:movielist/model/Movies.dart'; 
import 'package:movielist/view/shared/moviesCard.dart';

class userFavourites extends StatefulWidget {
  @override
  _userFavouritesState createState() => _userFavouritesState();
}

class _userFavouritesState extends State<userFavourites> {
  List<Results>? favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteMovies();
  }

  Future<void> _fetchFavoriteMovies() async {
    List<Results> fetchedFavorites = await userFavorites.getAllFavoriteMovies();
    setState(() {
      favoriteMovies = fetchedFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Favorites'),
      ),
      body: favoriteMovies == null || favoriteMovies!.isEmpty
          ? Center(
              child: Text(
                'No favorite movies',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favoriteMovies!.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies![index];
                return moviesCard(
                  item: movie,
                  isFavorite: true, 
                  onFavoriteToggle: (id) {
                    setState(() {
                      userFavorites.toggleFavorite(movie);
                      favoriteMovies!.remove(movie);
                    });
                  },
                );
              },
            ),
    );
  }
}
