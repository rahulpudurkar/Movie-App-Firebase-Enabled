import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movielist/controller/mostPopularController.dart';
import 'package:movielist/model/Movies.dart';
import 'package:movielist/view/shared/moviesCard.dart';
import 'package:movielist/model/userFavorites.dart';

class mostPopularMovies extends StatefulWidget {
  @override
  _mostPopularMoviesState createState() => _mostPopularMoviesState();
}

class _mostPopularMoviesState extends State<mostPopularMovies> {
  Movies? moviesList;
  List<Results>? filteredList;
  String? userId;

  final mostPopularController _controller = mostPopularController();

  @override
  void initState() {
    super.initState();
    _fetchMostPopularMovies();
    _fetchUserId();
  }

  void _fetchMostPopularMovies() async {
    try {
      final response = await _controller.fetchMostPopularMovies();
      final decodedResponse = json.decode(response.toString());
      final List<Results> fetchedMovies =
          Movies.fromJson(decodedResponse)?.results ?? [];

      
      for (Results movie in fetchedMovies) {
        final isFavorite =
            await userFavorites.isFavorite(movie.id ?? -1, userId ?? '');
        if (isFavorite) {
          userFavorites.userFavoriteIds.add(movie.id ?? -1);
        }
      }

      setState(() {
        moviesList = Movies.fromJson(decodedResponse);
        filteredList = fetchedMovies;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  
  void _fetchUserId() async {
    final _userId = await userFavorites.getUserIdFromCache();
    setState(() {
      userId = _userId;
    });
  }

  void toggleFavorite(Results movie) async {
    if (userId != null) {
      final isFavorite = await userFavorites.toggleFavorite(movie);
      print("Id : " + movie.id.toString() + " isFav : " + isFavorite.toString());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Most Popular'),
      ),
      body: filteredList != null
          ? ListView.builder(
              itemCount: filteredList!.length,
              itemBuilder: (context, index) {
                final movie = filteredList![index];
                return moviesCard(
                  item: movie,
                  isFavorite: userFavorites.userFavoriteIds.contains(movie.id),
                  onFavoriteToggle: toggleFavorite,
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
