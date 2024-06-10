import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllotSubjectsScreen extends StatelessWidget {
  final String userId;

  AllotSubjectsScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController subjectsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Allot Subjects'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: subjectsController,
              decoration: InputDecoration(labelText: 'Subjects (comma separated)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final subjects = subjectsController.text.split(',').map((s) => s.trim()).toList();

                if (subjects.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance.collection('users').doc(userId).update({
                      'subjects': subjects,
                    });

                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error: $e');
                  }
                }
              },
              child: Text('Allot'),
            ),
          ],
        ),
      ),
    );
  }
}
