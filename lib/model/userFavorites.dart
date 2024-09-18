import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielist/model/Movies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class userFavorites {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static HashSet<int> userFavoriteIds = HashSet<int>();

  static void clearUserFavoriteIds() {
    userFavoriteIds.clear();
  }

  static Future<List<Results>> getAllFavoriteMovies() async {
    List<Results> userFavorites = [];
    try {
      String? userId = await getUserIdFromCache();
      if (userId != null && userId.isNotEmpty) {
        final docRef = firestore.collection('favorites').doc(userId);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final userFavoritesData = docSnapshot.data() as Map<String, dynamic>;
          for (String movieId in userFavoritesData.keys) {
            final movieDetails = Results.fromJson(userFavoritesData[movieId]);

            
            if (movieDetails != null) {
              userFavorites.add(movieDetails);
            }

            
            print("Adding movie detail " + (movieDetails?.title ?? "No Title"));
          }
        }
      }
      return userFavorites;
    } catch (e) {
      print('Error fetching favorite movies: $e');
      return userFavorites;
    }
  }

  static Future<bool> isFavorite(int movieId, String userId) async {
    final docRef = firestore.collection('favorites').doc(userId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final userFavorites = docSnapshot.data() as Map<String, dynamic>;
      print("In is fav method -> " +
          userFavorites.containsKey(movieId.toString()).toString());
      return userFavorites.containsKey(movieId.toString());
    } else {
      print("docSnap doesnt exist");
      return false;
    }
  }

  static Future<bool> toggleFavorite(Results movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await getUserIdFromCache(); 
    if (userId == null || userId.isEmpty) {
      print('User ID not available');
      return false;
    }

    final int id = movie.id ?? -1;
    final movieData = movie.toJson();

    final docRef = firestore.collection('favorites').doc(userId);

    try {
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final userFavorites = docSnapshot.data() as Map<String, dynamic>;
        if (userFavorites.containsKey(id.toString())) {
          print("Removing " + id.toString());
          userFavorites.remove(id.toString());
          userFavoriteIds.remove(id); 
        } else {
          print("Adding " + id.toString());
          userFavorites[id.toString()] = movieData; 
          userFavoriteIds.add(id); 
        }

        print("Setting " + userFavorites.length.toString());

        await docRef.set(userFavorites);
        return true;
      } else {
        await docRef.set({id.toString(): movieData}); 
        userFavoriteIds.add(id); 
        return false;
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }

  static Future<String?> getUserIdFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    return userId ?? '';
  }
}
