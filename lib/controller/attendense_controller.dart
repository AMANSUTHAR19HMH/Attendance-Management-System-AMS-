import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  var isPresent = false.obs; // Adding attendance tracking

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });
}

class AttendanceController extends GetxController {
  var users = <User>[].obs;

  // Method to fetch users from Firestore
  void fetchUsers() {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      users.clear();
      querySnapshot.docs.forEach((doc) {
        users.add(User(
          id: doc.id,
          fullName: doc['fullName'],
          email: doc['email'],
          phone: doc['phone'],
        ));
      });
    }).catchError((error) {
      print("Error fetching users: $error");
    });
  }

  // Method to toggle attendance for a user
  void toggleAttendance(int index) {
    users[index].isPresent.value = !users[index].isPresent.value;
  }

  // Method to save attendance data to Firestore
  void saveAttendance(String sessionName) {
    List<Map<String, dynamic>> attendanceData = [];
    users.forEach((user) {
      attendanceData.add({
        'userId': user.id,
        'fullName': user.fullName,
        'email': user.email,
        'phone': user.phone,
        'isPresent': user.isPresent.value,
      });
    });

    FirebaseFirestore.instance
        .collection('attendance')
        .doc(sessionName) // Use sessionName as the document ID
        .set({'attendanceData': attendanceData})
        .then((_) {
      print('Attendance saved successfully!');
    }).catchError((error) {
      print('Failed to save attendance: $error');
    });
  }

  // Method to refresh attendance status
  void refreshAttendance() {
    for (var user in users) {
      user.isPresent.value = false;
    }
  }
}
