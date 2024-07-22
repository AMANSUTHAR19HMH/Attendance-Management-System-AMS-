import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/ManageAttendanceScreen.dart';

class UserDetailsScreen extends StatelessWidget {
  final DocumentSnapshot user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Email: ${user['email']}'),
            Text('Section: ${user['Class']}'),
            const SizedBox(height: 10),
            const Text('Details:'),
            Text('Name: ${user['username'] ?? 'N/A'}'),
            Text('Address: ${user['address'] ?? 'N/A'}'),
            const SizedBox(height: 10),
            const Text('Attendance:'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           AllotSubjectsScreen(userId: user.id)),
                // );
              },
              child: const Text('Allot Subjects'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const ManageAttendanceScreen()),
                // );
              },
              child: const Text('Manage Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
