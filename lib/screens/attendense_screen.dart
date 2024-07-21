import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/attendense_controller.dart'; // Adjust the path as per your project structure
class AttendanceScreen extends StatelessWidget {
  final AttendanceController attendanceController = Get.put(AttendanceController());

  AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch users and attendance initially
    attendanceController.fetchUsersAndAttendance();

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance List', style: GoogleFonts.montserrat()),
      ),
      body: Obx(() {
        if (attendanceController.users.isEmpty || attendanceController.attendance.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: attendanceController.users.length,
            itemBuilder: (context, index) {
              final user = attendanceController.users[index];
              final userAttendance = attendanceController.attendance
                  .where((attendance) => attendance.userId == user.id)
                  .toList();

              return ExpansionTile(
                title: Text(user.fullName),
                children: userAttendance.map((attendanceData) {
                  return ListTile(
                    title: Text(attendanceData.date),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: attendanceData.data.entries.map((entry) {
                        return Text('${entry.key}: ${entry.value}');
                      }).toList(),
                    ),
                  );
                }).toList(),
              );
            },
          );
        }
      }),
    );
  }
}
