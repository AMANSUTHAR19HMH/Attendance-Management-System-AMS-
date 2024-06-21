import 'package:attendance_management_system_ams/StartupDash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authntication/LoginScreen.dart';
import '../studetns/add Student Screen.dart';
import '../studetns/students detail.dart';
import '../studetns/studentseditscreen.dart';

class ManageStudentsScreen extends StatefulWidget {
  const ManageStudentsScreen({super.key});

  @override
  _ManageStudentsScreenState createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    _checkAdmin();
  }

  void _checkAdmin() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot userSnapshot =
            await usersCollection.doc(currentUser!.uid).get();
        if (userSnapshot.exists) {
          setState(() {
            isAdmin = true; // Assuming admin based on existence of user
          });
        }
      } catch (e) {
        print('Error checking admin role: $e');
        setState(() {
          isAdmin = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginDash()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['email']),
                trailing: isAdmin
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditUserScreen(
                                    userId: user.id,
                                    user: user,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              usersCollection.doc(user.id).delete();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.view_list),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetailsScreen(user: user),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUserScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
