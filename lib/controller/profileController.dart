import 'package:flutter/material.dart';
import 'package:movielist/model/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profileController {
  final Profile _Profile = Profile();

  Future<Map<String, dynamic>> getUserProfileFromCache() async {
    String? userId = await getUserIdFromCache();
    return _Profile.getUserProfile(userId ?? '');
  }

  Future<void> updateUserProfile(String name, String degree, String major, String imageUrl) async {
    String? userId = await getUserIdFromCache();
    await _Profile.updateUserProfile(userId ?? '', name, degree, major, imageUrl);
  }

Future<String> getUserIdFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  return userId ?? 'default-user-id';
}
}
