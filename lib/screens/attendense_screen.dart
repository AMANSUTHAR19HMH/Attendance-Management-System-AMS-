import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/attendense_controller.dart';

class AttendanceScreen extends StatelessWidget {
  final AttendanceController attendanceController =
      Get.put(AttendanceController());

  AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    attendanceController.fetchUsers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance List', style: GoogleFonts.montserrat()),
        actions: [
          TextButton(
            onPressed: () {
              showSessionNameDialog(context);
            },
            child: const Text(
              'Save Attendance',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          TextButton(
            onPressed: () {
              attendanceController.refreshAttendance();
            },
            child: const Text(
              'Refresh',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (attendanceController.users.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: attendanceController.users.length,
            itemBuilder: (context, index) {
              final user = attendanceController.users[index];
              return ListTile(
                title: Text('${user.fullName}'),
                subtitle: Text('${user.email} - ${user.phone}'),
                trailing: Obx(() => Checkbox(
                      value: user.isPresent.value,
                      onChanged: (value) {
                        attendanceController.toggleAttendance(index);
                      },
                    )),
              );
            },
          );
        }
      }),
    );
  }

  // Method to show dialog for entering session name
  void showSessionNameDialog(BuildContext context) {
    String sessionName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Session Name'),
          content: TextField(
            onChanged: (value) {
              sessionName = value;
            },
            decoration: InputDecoration(hintText: 'Session Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                attendanceController.saveAttendance(sessionName);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
