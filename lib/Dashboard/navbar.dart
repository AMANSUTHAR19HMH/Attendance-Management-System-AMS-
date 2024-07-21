import 'package:attendance_management_system_ams/Dashboard/profile.dart';
import 'package:attendance_management_system_ams/StartupDash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavbarTop extends StatelessWidget {
  const NavbarTop({super.key});

  Future<Map<String, String>> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("User not authenticated");
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        return {
          "fullName": data["username"] ?? "No Name",
          "email": data["email"] ?? "No Email",
        };
      } else {
        throw Exception("User document does not exist");
      }
    } catch (e) {
      throw Exception("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 215, 85, 219),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<Map<String, String>>(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const UserAccountsDrawerHeader(
                  accountName: Text("Loading..."),
                  accountEmail: Text("Loading..."),
                );
              } else if (snapshot.hasError) {
                return const UserAccountsDrawerHeader(
                  accountName: Text("Error"),
                  accountEmail: Text("Error"),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const UserAccountsDrawerHeader(
                  accountName: Text("No User"),
                  accountEmail: Text("No User"),
                );
              }

              final userData = snapshot.data!;
              return UserAccountsDrawerHeader(
                accountName: Text(userData["fullName"] ?? "No Name"),
                accountEmail: Text(userData["email"] ?? "No Email"),
              );
            },
          ),
          ListTile(
            textColor: Colors.white,
            iconColor: Colors.white,
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.maybePop(context);
            },
          ),
          ListTile(
            textColor: Colors.white,
            iconColor: Colors.white,
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const EditProfile()),
              );
            },
          ),
          const Divider(),
          ListTile(
            textColor: Colors.white,
            iconColor: Colors.white,
            leading: const Icon(Icons.logout_sharp),
            title: const Text("Logout"),
            onTap: () {
              _showLogoutConfirmation(context);
            },
          ),
        ],
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
