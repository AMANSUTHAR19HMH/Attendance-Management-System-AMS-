import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class navbar_top extends StatelessWidget {
  const navbar_top({Key? key}) : super(key: key);

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
          "name": data["name"] ?? "No Name",
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
                accountName: Text(userData["name"]!),
                accountEmail: Text(userData["email"]!),
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
