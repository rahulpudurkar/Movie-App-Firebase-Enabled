import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movielist/controller/nowPlayingController.dart';
import 'package:movielist/model/Movies.dart';
import 'package:movielist/view/shared/moviesCard.dart';
import 'package:movielist/model/userFavorites.dart';

class nowPlayingMovies extends StatefulWidget {
  @override
  _nowPlayingMoviesState createState() => _nowPlayingMoviesState();
}

class _nowPlayingMoviesState extends State<nowPlayingMovies> {
  Movies? moviesList;
  List<Results>? filteredList;
  String? userId;

  final nowPlayingController _controller = nowPlayingController();

  @override
  void initState() {
    super.initState();
    _fetchNowPlayingMovies();
    _fetchUserId();
  }

  void _fetchNowPlayingMovies() async {
    try {
      final response = await _controller.fetchNowPlayingMovies();
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
        title: Text('Now Playing'),
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
