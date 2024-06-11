import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserScreen extends StatelessWidget {
  final DocumentSnapshot user;

  const EditUserScreen({super.key, required this.user, required String userId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController(text: user['email']);
    final TextEditingController roleController = TextEditingController(text: user['role']);
    final TextEditingController sectionController = TextEditingController(text: user['section']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: sectionController,
              decoration: const InputDecoration(labelText: 'Section'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String email = emailController.text;
                final String role = roleController.text;
                final String section = sectionController.text;

                if (email.isNotEmpty && role.isNotEmpty && section.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance.collection('users').doc(user.id).update({
                      'email': email,
                      'role': role,
                      'section': section,
                    });

                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error: $e');
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
