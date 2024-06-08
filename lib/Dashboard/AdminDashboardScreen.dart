import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/ManageAttendanceScreen.dart';
import '../screens/ManageEventsScreen.dart';
import '../screens/ManageStudentsScreen.dart';
import '../screens/ManageSubjectsScreen.dart';
import '../screens/ViewAttendanceScreen.dart';


class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildDashboardItem('Manage Students', Icons.person, Colors.blue, () {
            Get.to(ManageStudentsScreen());
          }),
          _buildDashboardItem('Manage Attendance', Icons.calendar_today, Colors.green, () {
            Get.to(ManageAttendanceScreen());
          }),
          _buildDashboardItem('Manage Events', Icons.event, Colors.orange, () {
            Get.to(ManageEventsScreen());
          }),
          _buildDashboardItem('Manage Subjects', Icons.subject, Colors.purple, () {
            Get.to(ManageSubjectsScreen());
          }),
          _buildDashboardItem('View Attendance', Icons.view_list, Colors.red, () {
            Get.to(ViewAttendanceScreen());
          }),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        margin: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
