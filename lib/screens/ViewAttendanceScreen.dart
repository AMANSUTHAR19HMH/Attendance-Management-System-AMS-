import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAttendanceScreen extends StatelessWidget {
  final CollectionReference attendanceCollection = FirebaseFirestore.instance.collection('attendance');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Attendance'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: attendanceCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final attendanceRecords = snapshot.data!.docs;

          return ListView.builder(
            itemCount: attendanceRecords.length,
            itemBuilder: (context, index) {
              final record = attendanceRecords[index];
              return ListTile(
                title: Text(record['studentName']),
                subtitle: Text('Subject: ${record['subject']}'),
                trailing: Text(record['date']),
              );
            },
          );
        },
      ),
    );
  }
}
