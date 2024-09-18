import 'package:flutter/material.dart';
import 'package:movielist/controller/profileController.dart';
import 'package:movielist/controller/userProfileController.dart';
import 'package:movielist/model/userFavorites.dart';
import 'package:movielist/view/editProfile.dart';
import 'package:movielist/view/loginView.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final profileController _userProfileController = profileController();
  late TextEditingController _nameController;
  late TextEditingController _degreeController;
  late TextEditingController _majorController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _degreeController = TextEditingController();
    _majorController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _degreeController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              userFavorites.clearUserFavoriteIds();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => loginView()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userProfileController.getUserProfileFromCache(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> userProfile = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      print("Hello, World!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => editProfile(
                            initialName: userProfile['name'],
                            initialDegree: userProfile['degree'],
                            initialMajor: userProfile['major'],
                            initialImageUrl: userProfile['imageUrl'],
                            onSave: (name, degree, major, imageUrl) {
                              print(name);
                              _userProfileController.updateUserProfile(
                                  name, degree, major, imageUrl ?? '');
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(12.0),
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 2.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: userProfile['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          userProfile['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
