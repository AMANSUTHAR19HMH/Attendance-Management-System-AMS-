import 'package:attendance_management_system_ams/Dashboard/profile.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'profile.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../authntication/LoginScreen.dart';
import '../screens/attendense_screen.dart';


// Main Function
void main() {
  runApp(DashboardScreen());
}

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../authntication/LoginScreen.dart';
import '../screens/attendense_screen.dart';
import 'navbar.dart';
// Main Function


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
        home: const dashboard());

      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const HomeScreen(),
    );

  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _dashboardState extends State<dashboard> {

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

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const navbar_top(),
      appBar: AppBar(
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

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  title: Text(
                    'Hi Jack William',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Welcome to AMS',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),


          // Main Dashboard Components for navigation ///

          // Main Dashboard Components for navigation

          // Main Dashboard Components for navigation

          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(

                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(100))),

                color: Colors.white,
              ),

                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
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

                  itemDashboard(
                      'Attendance', CupertinoIcons.calendar, Colors.blueAccent),

                  itemDashboard('Notifications', FontAwesomeIcons.bell,
                      Colors.yellowAccent.shade400),
                  itemDashboard(
                      'Events', FontAwesomeIcons.star, Colors.orangeAccent),

                  itemDashboard('Profile', FontAwesomeIcons.user,
                      Colors.greenAccent.shade700),
                  itemDashboard(
                      'Admin', FontAwesomeIcons.userLock, Colors.cyan.shade900),

                  itemDashboard(
                      'Attendance', CupertinoIcons.calendar, Colors.blueAccent),
                  itemDashboard('Profile', CupertinoIcons.profile_circled,
                      Colors.greenAccent.shade700),
                  itemDashboard(
                      'Events', FontAwesomeIcons.star, Colors.orangeAccent),
                  itemDashboard('Notifications', FontAwesomeIcons.bell,
                      Colors.yellowAccent.shade400),
                  itemDashboard('Admin', CommunityMaterialIcons.lock,
                      Colors.greenAccent.shade700),

                  itemDashboard('Logout', CommunityMaterialIcons.logout,
                      Colors.red.shade400),
                  itemDashboard('Profile', CupertinoIcons.profile_circled,
                      Colors.greenAccent.shade700),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 165, 149, 149),
        child: GNav(
          gap: 8,
          backgroundColor: Color.fromARGB(255, 165, 149, 149),
          color: Colors.white,
          activeColor: Colors.blueGrey.shade900,
          tabs: [
            GButton(
              icon: Icons.dashboard,
            ),
            GButton(icon: Icons.calendar_month_outlined),
            GButton(icon: Icons.qr_code_scanner),
            GButton(icon: Icons.person),
          ],
        ),
      ),
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
              spreadRadius: 2,
              blurRadius: 5,
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

  void _logoutAndNavigateToLogin(BuildContext context) {
    // Perform logout action
    // For example, you can use FirebaseAuth.instance.signOut() if you're using Firebase Authentication.

    // Navigate to the login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
