import 'package:flutter/material.dart';
import 'package:movielist/model/Movies.dart';
import 'package:movielist/view/shared/movieDetails.dart';

class moviesCard extends StatelessWidget {
  final Results item;
  final bool isFavorite;
  final Function(Results) onFavoriteToggle;

  const moviesCard({
    Key? key,
    required this.item,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => movieDetails(movieId: item.id ?? 0,isFavorite: this.isFavorite ?? false),
          ),
        );
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (item.posterPath != null) _buildPosterImage(item.posterPath),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.title ?? '',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  onFavoriteToggle(item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosterImage(String? posterPath) {
    if (posterPath != null) {
      return Image.network(
        'https://image.tmdb.org/t/p/w200$posterPath',
        width: 100,
        height: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Placeholder(
        color: Colors.grey,
        fallbackHeight: 150,
        fallbackWidth: 100,
      );
    }
  }
}
