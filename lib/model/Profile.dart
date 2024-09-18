import 'package:cloud_firestore/cloud_firestore.dart'; 

class Profile {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(userId).get();
    return snapshot.data() ?? {};
  }

  Future<void> updateUserProfile(String userId, String name, String degree, String major, String? imageUrl) async {
    Map<String, dynamic> dataToUpdate = {
      'name': name,
      'degree': degree,
      'major': major,
      'imageUrl': imageUrl,
    };

    await _firestore.collection('users').doc(userId).update(dataToUpdate);
  }
}
