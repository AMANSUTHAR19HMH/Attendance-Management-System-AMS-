import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  var isPresent = false.obs;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });
}

class AttendanceData {
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final String date;
  final Map<String, dynamic> data;

  AttendanceData({
    required this.date,
    required this.data,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
  });
}

class AttendanceController extends GetxController {
  var users = <User>[].obs;
  var attendance = <AttendanceData>[].obs;
  var presentCount = 0.obs;
  var absentCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsersAndAttendance();
  }

  void fetchUsers() {
    FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
      users.clear();
      for (var doc in querySnapshot.docs) {
        users.add(User(
          id: doc.id,
          fullName: doc['fullName'],
          email: doc['email'],
          phone: doc['phone'],
        ));
      }
    }).catchError((error) {
      print("Error fetching users: $error");
    });
  }

  void fetchUsersAndAttendance() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      users.clear();
      for (var userDoc in querySnapshot.docs) {
        users.add(User(
          id: userDoc.id,
          fullName: userDoc['fullName'],
          email: userDoc['email'],
          phone: userDoc['phone'],
        ));

        var attendanceSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('attendance')
            .get();

        for (var doc in attendanceSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            attendance.add(AttendanceData(
              userId: userDoc.id,
              fullName: userDoc['fullName'] ?? '',
              email: userDoc['email'] ?? '',
              phone: userDoc['phone'] ?? '',
              date: doc.id,
              data: data,
            ));
          }
        }
      }
    } catch (error) {
      print("Error fetching users and attendance: $error");
    }
  }

  void toggleAttendance(int index) {
    var user = users[index];
    user.isPresent.value = !user.isPresent.value;
    if (user.isPresent.value) {
      presentCount++;
      absentCount--;
    } else {
      presentCount--;
      absentCount++;
    }
  }

  void saveAttendance(String sessionName) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      List<Map<String, dynamic>> attendanceData = [];
      for (var user in users) {
        attendanceData.add({
          'userId': user.id,
          'fullName': user.fullName,
          'email': user.email,
          'phone': user.phone,
          'isPresent': user.isPresent.value,
        });
      }

      var attendanceDocRef =
          FirebaseFirestore.instance.collection('attendance').doc(sessionName);
      transaction.set(attendanceDocRef, {'attendanceData': attendanceData});
    }).then((_) {
      print('Attendance saved successfully!');
    }).catchError((error) {
      print('Failed to save attendance: $error');
    });
  }

  void refreshAttendance() {
    for (var user in users) {
      user.isPresent.value = false;
    }
    presentCount.value = 0;
    absentCount.value = users.length;
  }

  User getLoggedInUser() {
    return User(
      id: '1',
      fullName: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1234567890',
    );
  }

  void fetchUserAttendance(String userEmail) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('attendance')
        .get()
        .then((querySnapshot) {
      attendance.clear();
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          attendance.add(AttendanceData(
            date: doc.id,
            data: data,
            userId: data['userId'] ?? '',
            fullName: data['fullName'] ?? '',
            email: data['email'] ?? '',
            phone: data['phone'] ?? '',
          ));
        }
      }
    }).catchError((error) {
      print("Error fetching user's attendance: $error");
    });
  }
}
