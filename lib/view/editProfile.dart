import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class editProfile extends StatefulWidget {
  final String initialName;
  final String initialDegree;
  final String initialMajor;
  final String initialImageUrl;
  final Function(String name, String degree, String major, String? imageUrl)
      onSave;

  editProfile({
    required this.initialName,
    required this.initialDegree,
    required this.initialMajor,
    required this.initialImageUrl,
    required this.onSave,
  });

  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  late TextEditingController _nameController;
  late TextEditingController _degreeController;
  late TextEditingController _majorController;
  String? _imageUrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _degreeController = TextEditingController(text: widget.initialDegree);
    _majorController = TextEditingController(text: widget.initialMajor);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _degreeController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _saving = true; 
      });
      File imageFile = File(pickedFile.path);
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('user_image.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      if (pickedFile != null) {
        setState(() {
          _imageUrl = downloadURL;
          _saving = false; 
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _degreeController,
                  decoration: InputDecoration(
                    labelText: 'Degree',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _majorController,
                  decoration: InputDecoration(
                    labelText: 'Major',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Edit Profile Image'),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _saving = true;
                    });
                    widget.onSave(
                      _nameController.text,
                      _degreeController.text,
                      _majorController.text,
                      _imageUrl ?? widget.initialImageUrl,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
          if (_saving)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
