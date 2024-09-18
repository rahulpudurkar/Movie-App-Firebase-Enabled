import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movielist/controller/movieDetailController.dart';
import 'package:movielist/model/MovieDetails.dart';
import 'package:movielist/view/shared/imagesGallery.dart';

class movieDetails extends StatefulWidget {
  final int movieId;
  final bool isFavorite;

  movieDetails({required this.movieId, required this.isFavorite});

  @override
  _movieDetailsState createState() => _movieDetailsState();
}

class _movieDetailsState extends State<movieDetails> {
  MovieDetails? movieDetail;
  final movieDetailController _controller = movieDetailController();

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  void _fetchMovieDetails() async {
    try {
      final response = await _controller.fetchMovieDetailsById(widget.movieId);
      final decodedResponse = json.decode(response.toString());
      setState(() {
        movieDetail = MovieDetails.fromJson(decodedResponse);
      });
    } catch (e) {
      print('Error fetching movie details: $e');
    }
  }

  Widget _buildGenreChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: movieDetail?.genres?.map((genre) => Chip(
        label: Text(genre?.name ?? ''),
        backgroundColor: Colors.red,
      )).toList() ?? [],
    );
  }

  Widget _buildOverview() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        movieDetail?.overview ?? 'No overview available.',
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildReleaseDateAndRating() {
    int numberOfStars = ((movieDetail?.voteAverage ?? 0) / 2).ceil();
    String releaseDate = movieDetail?.releaseDate != null
        ? DateFormat('MMMM dd, yyyy').format(movieDetail!.releaseDate!)
        : 'Unknown';

    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text('Release Date'),
          subtitle: Text(releaseDate),
        ),
        ListTile(
          leading: Icon(widget.isFavorite ? Icons.favorite : Icons.favorite_border),
          title: Text('Favorite'),
          subtitle: Text(widget.isFavorite ? 'In Favorites' : 'Not in Favorites'),
        ),
        ListTile(
          leading: Icon(Icons.star),
          title: Text('Rating'),
          subtitle: Text('$numberOfStars Stars'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movieDetail?.title ?? 'Loading...')),
      body: movieDetail == null ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: _buildGenreChips(),
            ),
            Divider(),
            _buildOverview(),
            Divider(),
            _buildReleaseDateAndRating(),
            Divider(),
            imagesGallery(
              imageUrls: [
                'https://image.tmdb.org/t/p/w500${movieDetail!.posterPath}',
                'https://image.tmdb.org/t/p/w500${movieDetail!.backdropPath}',
              ],
            ),
          ],
        ),
      ),
    );
  }
}
