import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageAttendanceScreen extends StatelessWidget {
  final String userId;

  ManageAttendanceScreen({required this.userId});

  final TextEditingController dateController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
            ),
            TextField(
              controller: statusController,
              decoration: InputDecoration(labelText: 'Status (Present/Absent)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final date = dateController.text.trim();
                final status = statusController.text.trim();

                if (date.isNotEmpty && status.isNotEmpty) {
                  if (status.toLowerCase() == 'present' || status.toLowerCase() == 'absent') {
                    try {
                      await FirebaseFirestore.instance.collection('users').doc(userId).update({
                        'attendance.$date': status,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Attendance updated successfully for $date')),
                      );
                    } catch (e) {
                      print('Error updating attendance: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update attendance')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid status (Present/Absent)')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter both date and status')),
                  );
                }
              },
              child: Text('Update Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
