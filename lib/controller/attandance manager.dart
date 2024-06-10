import 'package:cloud_firestore/cloud_firestore.dart';

// Function to update attendance in Firestore
Future<void> updateAttendance(String userId, bool isPresent) async {
  try {
    // Update attendance status for the user in Firestore
    await FirebaseFirestore.instance.collection('attendance').doc(userId).set({
      'isPresent': isPresent,
      'timestamp': Timestamp.now(),
    }, SetOptions(merge: true));
  } catch (e) {
    print('Error updating attendance: $e');
  }
}
