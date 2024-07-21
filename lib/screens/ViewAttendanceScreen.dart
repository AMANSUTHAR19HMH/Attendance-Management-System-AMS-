import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAttendanceScreen extends StatelessWidget {
  final CollectionReference attendanceCollection =
      FirebaseFirestore.instance.collection('attendance');

  ViewAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: attendanceCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No attendance records found.'));
          }

          final attendanceRecords = snapshot.data!.docs;

          return ListView.builder(
            itemCount: attendanceRecords.length,
            itemBuilder: (context, index) {
              final record = attendanceRecords[index];
              final attendance = record.data() as Map<String, dynamic>;

              // Display all fields in the document
              final fields = attendance.entries
                  .map((entry) => '${entry.key}: ${entry.value}')
                  .join('\n');

              return ListTile(
                title: const Text('Attendance Record'),
                subtitle: Text(fields.isEmpty ? 'No Attendance Data' : fields),
                onTap: () {
                  // Handle tap event if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
