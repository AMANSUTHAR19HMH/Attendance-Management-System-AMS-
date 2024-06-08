import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavbarTop extends StatelessWidget {
  const NavbarTop({Key? key}) : super(key: key);

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
        print("Fetched data: $data"); // Debug output
        return {
          "fullName": data["fullName"] ?? "No Name",
          "email": data["email"] ?? "No Email",
        };
      } else {
        throw Exception("User document does not exist");
      }
    } catch (e) {
      print("Error fetching user data: $e"); // Debug output
      throw Exception("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<Map<String, String>>(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return UserAccountsDrawerHeader(
                  accountName: Text("Loading..."),
                  accountEmail: Text("Loading..."),
                );
              } else if (snapshot.hasError) {
                return UserAccountsDrawerHeader(
                  accountName: Text("Error"),
                  accountEmail: Text("Error"),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return UserAccountsDrawerHeader(
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
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text("Attendance"),
            onTap: () {
              Navigator.pushNamed(context, '/attendance');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.logout_sharp),
            title: const Text("Logout"),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
