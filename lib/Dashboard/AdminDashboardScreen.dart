import 'package:attendance_management_system_ams/Dashboard/QrScanner.dart';
import 'package:attendance_management_system_ams/screens/ManageTeachers.dart';
import 'package:attendance_management_system_ams/teachers/TeacherDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const MarkAttendance(),
    ViewAttendanceScreen(),
    const MoreDetails(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              onPressed: () => {
                FirebaseAuth.instance.signOut(),
                Navigator.maybePop(context),
              },
              icon: Icon(Icons.logout_outlined),
            ),
          ],
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              label: 'Mark Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'View Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_sharp),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 253, 143, 0),
          onTap: _onItemTapped,
        ));
  }
}

class MoreDetails extends StatefulWidget {
  const MoreDetails({super.key});

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildDashboardItem(
              'Manage Students', 'assets/CustomIcons/Student.png', Colors.blue,
              () {
            Get.to(const ManageStudentsScreen());
          }),
          _buildDashboardItem('Manage Teachers',
              'assets/CustomIcons/teacher.png', Colors.pinkAccent, () {
            Get.to(const ManageTeachersScreen());
          }),
          _buildDashboardItem('Manage Events', 'assets/CustomIcons/Event.png',
              const Color.fromARGB(212, 255, 153, 0), () {
            Get.to(const ManageEventsScreen());
          }),
          _buildDashboardItem('Manage Subjects',
              'assets/CustomIcons/Subject.png', Colors.purple, () {
            Get.to(const ManageSubjectsScreen());
          }),
          _buildDashboardItem('Qr Scanner', "assets/CustomIcons/Qr_scan.png",
              const Color.fromARGB(255, 57, 176, 39), () {
            Get.to(const QrScanner());
          }),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(
      String title, String icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        margin: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(icon),
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
