import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('users').doc(userId).get();

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        // User profile not found
        return {};
      }
    } catch (error) {
      print("Error fetching user profile: $error");
      return {};
    }
  }
}
