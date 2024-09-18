import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movielist/model/Movies.dart';

class mostPopularController {
  final String baseUrl = 'https://api.themoviedb.org/3/movie/popular?api_key=ac65dbeb5db8a7fc4848dde915a0b42c';

  Future<Object?> fetchMostPopularMovies() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl'));
    if (response.statusCode == 200) {
      return (response.body);
    } else {
      throw Exception('Response code ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching top rated movies: $e');
  }
}

}
