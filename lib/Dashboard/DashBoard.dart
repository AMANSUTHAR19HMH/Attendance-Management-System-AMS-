import 'package:attendance_management_system_ams/StartupDash.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../Dashboard/profile.dart';
import '../screens/EventsScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Main Dashboard Components for navigation ///
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  top: 50,
                ),
                crossAxisSpacing: 50,
                mainAxisSpacing: 30,
                // DashBoard Icons
                children: [
                  // QR Attendance icon
                  itemDashboard(() {}, 'Notifications', FontAwesomeIcons.bell,
                      Colors.yellowAccent.shade400, context),
                  itemDashboard(() {
                    Get.to(EventsScreen());
                  }, 'Events', FontAwesomeIcons.star, Colors.orangeAccent,
                      context),
                  itemDashboard(() {
                    Get.to(const EditProfile());
                  }, 'Profile', FontAwesomeIcons.user,
                      Colors.greenAccent.shade700, context),
                  // itemDashboard(
                  //     'Admin', FontAwesomeIcons.userLock, Colors.cyan.shade900),
                  itemDashboard(() {
                    _showLogoutConfirmation(context);
                  }, 'Logout', CommunityMaterialIcons.logout,
                      Colors.red.shade400, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DashBoard Icons Function to store details of icons
  Widget itemDashboard(VoidCallback onTapCallback, String title,
      IconData iconData, Color background, BuildContext context) {
    return Container(
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
      child: GestureDetector(
        onTap: onTapCallback,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
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

  void _logoutAndNavigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginDash()),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut;
                _logoutAndNavigateToLogin(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
