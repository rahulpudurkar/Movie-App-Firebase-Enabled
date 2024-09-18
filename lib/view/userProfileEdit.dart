import 'dart:io';
import 'package:flutter/material.dart';
import 'package:movielist/controller/userProfileController.dart';
import 'package:movielist/view/home.dart';

class userProfileEdit extends StatefulWidget {
  @override
  _userProfileEditState createState() => _userProfileEditState();
}

class _userProfileEditState extends State<userProfileEdit> {
  final userProfileController controller = userProfileController();
  late Future<String?> _userIdFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userIdFuture = controller.getUserIdFromCache();
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Profile'),
      ),
      body: FutureBuilder<String?>(
        future: _userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text("No user ID found"));
          } else {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildTextField('Name', controller.name),
                  buildTextField('Degree', controller.degree),
                  buildTextField('Major', controller.major),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.pickImage();
                    },
                    child: Text('Upload Profile Image'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          Map<String, dynamic> result = await controller.saveProfile(snapshot.data!);
                          setState(() => _isLoading = false);
                          final snackBar = SnackBar(
                            content: Text(result["success"] ? "Profile updated successfully." : "Failed to update profile: ${result['message']}"),
                            backgroundColor: result["success"] ? Colors.green : Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          if (result["success"]) {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home()));
                          }
                        },
                        child: Text('Save Profile'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
