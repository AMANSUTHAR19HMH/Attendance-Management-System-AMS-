import 'package:attendance_management_system_ams/Dashboard/profile.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../authntication/LoginScreen.dart';
import '../screens/attendense_screen.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

import 'navbar.dart';

void main() {
  runApp(DashboardScreen());
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const dash_Screen(),
    );
  }
}

class dash_Screen extends StatefulWidget {
  const dash_Screen({super.key});

  @override
  State<dash_Screen> createState() => _dash_ScreenState();
}

class _dash_ScreenState extends State<dash_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const navbar_top(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        title: Text(
          "DashBoard",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 1,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Main Dashboard Components for navigation ///

          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: 50,
                ),
                crossAxisSpacing: 50,
                mainAxisSpacing: 30,
                // DashBoard Icons
                children: [
                  itemDashboard('Attendance', FontAwesomeIcons.calendar,
                      Colors.blueAccent),
                  itemDashboard('Notifications', FontAwesomeIcons.bell,
                      Colors.yellowAccent.shade400),
                  itemDashboard(
                      'Events', FontAwesomeIcons.star, Colors.orangeAccent),
                  itemDashboard('Profile', FontAwesomeIcons.user,
                      Colors.greenAccent.shade700),
                  itemDashboard(
                      'Admin', FontAwesomeIcons.userLock, Colors.cyan.shade900),
                  itemDashboard('Logout', CommunityMaterialIcons.logout,
                      Colors.red.shade400),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation  //
      bottomNavigationBar: Container(
        color: Colors.purple,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: GNav(
            backgroundColor: Colors.purple,
            color: Colors.white,
            activeColor: Colors.grey,
            padding: EdgeInsets.all(8),
            gap: 8,
            tabs: [
              GButton(icon: Icons.dashboard),
              GButton(icon: Icons.calendar_month_rounded),
              GButton(
                icon: Icons.qr_code_scanner_rounded,
              ),
              GButton(icon: Icons.notifications),
              GButton(icon: Icons.person),
            ],
          ),
        ),
      ),
    );
  }

  // DashBoard Icons Function to store details of icons

  void _logoutAndNavigateToLogin(BuildContext context) {
    // Perform logout action
    // For example, you can use FirebaseAuth.instance.signOut() if you're using Firebase Authentication.

    // Navigate to the login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action and navigate to login screen
                _logoutAndNavigateToLogin(context);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  // DashBoard Icons Function to store details of icons
  Widget itemDashboard(String title, IconData iconData, Color background) {
    return GestureDetector(
      onTap: () {
        if (title == 'Attendance') {
          Get.to(AttendanceScreen());
        } else if (title == 'Profile') {
          Get.to(Profile());
        } else if (title == 'Logout') {
          _showLogoutConfirmation(context);
        } else {
          // Handle navigation for other items
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 4,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
