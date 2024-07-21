import 'package:attendance_management_system_ams/StartupDash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          print("Admin status set to true for user ${currentUser!.uid}");
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
    print("Building ManageStudentsScreen. isAdmin: $isAdmin");

    return Scaffold(
      backgroundColor:
          Colors.grey[200], // Set your desired background color here
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;
          print("Number of users: ${users.length}");

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              print("Building ListTile for user: ${user['username']}");

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Column(children: [
                    Row(
                      children: [
                        Text(user['username']),
                      ],
                    ),
                    Row(
                      children: [
                        Text(user['email']),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.edit,
                              color: Color.fromARGB(255, 7, 68, 119)),
                          label: const Text('Edit',
                              style: TextStyle(color: Colors.blue)),
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
                        TextButton.icon(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                          onPressed: () async {
                            await usersCollection.doc(user.id).delete();
                            await FirebaseAuth.instance.currentUser!
                                .delete(); // Deleting user from Firebase Auth as well
                          },
                        ),
                        TextButton.icon(
                          icon:
                              const Icon(Icons.view_list, color: Colors.green),
                          label: const Text('View',
                              style: TextStyle(color: Colors.green)),
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
                    ),
                  ]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
