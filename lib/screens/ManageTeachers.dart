import 'package:attendance_management_system_ams/teachers/AddTeacher.dart';
import 'package:attendance_management_system_ams/teachers/EditTeachers.dart';
import 'package:attendance_management_system_ams/teachers/TeachersDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:attendance_management_system_ams/StartupDash.dart';

class ManageTeachersScreen extends StatefulWidget {
  const ManageTeachersScreen({super.key});

  @override
  State<ManageTeachersScreen> createState() => _ManageTeachersScreenState();
}

class _ManageTeachersScreenState extends State<ManageTeachersScreen> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("teachers");
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
          title: const Text('Manage Teachers'),
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
                return Card(
                  color: Color.fromARGB(255, 172, 174, 177),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                      title: Column(
                    children: [
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
                                  builder: (context) => EditTeachers(
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
                            icon: const Icon(Icons.view_list,
                                color: Colors.green),
                            label: const Text('View',
                                style: TextStyle(color: Colors.green)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TeachersDetails(user: user),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTeacher()),
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
