import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/ManageAttendanceScreen.dart';
import 'alot Subjects.dart';

class UserDetailsScreen extends StatelessWidget {
  final DocumentSnapshot user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final details = user['details'] ?? {};
    final subjects = user['subjects'] ?? [];
    final attendance = user['attendance'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Email: ${user['email']}'),
            Text('Role: ${user['role']}'),
            Text('Section: ${user['section']}'),
            const SizedBox(height: 10),
            const Text('Details:'),
            Text('Name: ${details['name'] ?? 'N/A'}'),
            Text('Age: ${details['age'] ?? 'N/A'}'),
            Text('Address: ${details['address'] ?? 'N/A'}'),
            const SizedBox(height: 10),
            const Text('Subjects:'),
            for (var subject in subjects) Text(subject),
            const SizedBox(height: 10),
            const Text('Attendance:'),
            for (var date in attendance.keys) Text('$date: ${attendance[date]}'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllotSubjectsScreen(userId: user.id)),
                );
              },
              child: const Text('Allot Subjects'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageAttendanceScreen(userId: user.id)),
                );
              },
              child: const Text('Manage Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
