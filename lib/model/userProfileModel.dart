import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveAdditionalInfo(String userId, String name, String degree, String major, String? imageUrl) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'degree': degree,
        'major': major,
      };

      if (imageUrl != null) {
        data['imageUrl'] = imageUrl;
      }

      await _firestore.collection('users').doc(userId).set(data);
    } catch (e) {
      throw Exception('Failed to save additional profile information: $e');
    }
  }
}
