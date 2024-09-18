import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:movielist/model/userProfileModel.dart';
import 'package:movielist/model/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class userProfileController {
  final UserProfile model = UserProfile();

  final TextEditingController name = TextEditingController();
  final TextEditingController degree = TextEditingController();
  final TextEditingController major = TextEditingController();

  static Uint8List? fileBytes;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      fileBytes = await pickedFile.readAsBytes();
    } else {
      fileBytes = null;
    }
  }

  Future<Map<String, dynamic>> saveProfile(String userId) async {
    try {
      String? imageUrl = await _uploadImage(userId);
      await model.saveAdditionalInfo(
        userId,
        name.text,
        degree.text,
        major.text,
        imageUrl,
      );
      return {
        "success": true,
        "message": "",
      };
    } catch (e) {
      print('Failed to save profile: $e');
      return {
        "success": false,
        "message":
            e.toString(), 
      };
    }
  }

  Future<String?> getUserIdFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> _uploadImage(String userId) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child('profile_images').child('$userId.jpg');

      if (fileBytes == null) {
        print('No file selected to upload.');
        return null;
      }

      UploadTask uploadTask = ref.putData(fileBytes!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }
}
