import 'package:attendance_management_system_ams/Dashboard/QrScanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/ManageAttendanceScreen.dart';
import '../screens/ManageEventsScreen.dart';
import '../screens/ManageStudentsScreen.dart';
import '../screens/ManageSubjectsScreen.dart';
import '../screens/ViewAttendanceScreen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildDashboardItem('Manage Students', Icons.person, Colors.blue, () {
            Get.to(const ManageStudentsScreen());
          }),
          _buildDashboardItem(
              'Manage Attendance', Icons.calendar_today, Colors.green, () {
            Get.to(ManageAttendanceScreen(
              userId: '',
            ));
          }),
          _buildDashboardItem('Manage Events', Icons.event, Colors.orange, () {
            Get.to(const ManageEventsScreen());
          }),
          _buildDashboardItem('Manage Subjects', Icons.subject, Colors.purple,
              () {
            Get.to(const ManageSubjectsScreen());
          }),
          _buildDashboardItem('Qr Scanner', Icons.subject, Colors.purple, () {
            Get.to(const QrScanner());
          }),
          _buildDashboardItem('View Attendance', Icons.view_list, Colors.red,
              () {
            Get.to(ViewAttendanceScreen());
          }),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        margin: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
