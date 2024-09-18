import 'dart:convert';
import 'package:http/http.dart' as http;

class movieDetailController {

  Future<Object?> fetchMovieDetailsById(int movieId) async {
  try {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/'+movieId.toString()+'?api_key=33466375d8ada87b7db76d4ce6666906'));
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