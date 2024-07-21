import 'package:attendance_management_system_ams/Dashboard/DashBoard.dart';
import 'package:attendance_management_system_ams/StartupDash.dart';
import 'package:attendance_management_system_ams/screens/ViewAttendanceScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../Dashboard/profile.dart';
import '../controller/UserProfileQRCode.dart';
import '../screens/EventsScreen.dart';
import '../screens/ProfileScreen.dart';
import '../screens/attendense_screen.dart';
import 'navbar.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  _StudentDashboardScreenState createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(), // Assuming this is your main dashboard screen
    UserProfileQRCode(userId: FirebaseAuth.instance.currentUser?.uid ?? ""),
    const ProfileScreen(),
    ViewAttendanceScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavbarTop(),
        appBar: AppBar(
          foregroundColor: const Color.fromARGB(255, 215, 85, 219),
          title: const Text(
            "Dashboard",
            style: TextStyle(
              color: Color.fromARGB(255, 215, 85, 219),
            ),
          ),
          elevation: 3,
          actions: [
            IconButton(
                onPressed: () {
                  _showLogoutConfirmation(context);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 215, 85, 219),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
              child: GNav(
                rippleColor: const Color.fromARGB(255, 255, 255, 255),
                hoverColor: Colors.grey[100]!,
                gap: 3,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
                color: const Color.fromARGB(255, 255, 255, 255),
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                    onPressed: () {
                      _onItemTapped(0);
                    },
                  ),
                  GButton(
                    icon: LineIcons.list,
                    text: "View Attendance",
                    textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
                    onPressed: () {
                      _onItemTapped(3);
                    },
                  ),
                  GButton(
                    icon: LineIcons.qrcode,
                    text: "OR",
                    onPressed: () {
                      _onItemTapped(1);
                    },
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'Profile',
                    onPressed: () {
                      _onItemTapped(2);
                    },
                  ),
                ],
              ),
            ),
          ),
        )
        // Bottom Navigation  //
        );
  }

  // DashBoard Icons Function to store details of icons
  Widget itemDashboard(String title, IconData iconData, Color background) {
    return GestureDetector(
      onTap: () {
        if (title == 'Attendance') {
          Get.to(AttendanceScreen());
        } else if (title == 'QR Attendance') {
          // Get the current user ID from Firebase Authentication
          String? userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileQRCode(
                  userId: userId,
                ),
              ),
            );
          } else {
            // Handle scenario when user is not logged in
            print('User is not logged in.');
          }
        } else if (title == 'Events') {
          Get.to(EventsScreen());
        } else if (title == 'Profile') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const EditProfile()),
          );
        } else if (title == 'Logout') {
          Get.to(const LoginDash());
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

  void _logoutAndNavigateToLogin(BuildContext context) {
    FirebaseAuth.instance.signOut();
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
