import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();

  AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
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
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
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
                final String password = passwordController.text;
                final String role = roleController.text.isNotEmpty
                    ? roleController.text
                    : 'user';

                final String section = sectionController.text;

                if (email.isNotEmpty &&
                    password.isNotEmpty &&
                    role.isNotEmpty &&
                    section.isNotEmpty) {
                  try {
                    UserCredential userCredential =
                        await auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    await usersCollection.doc(userCredential.user?.uid).set({
                      'email': email,
                      'role': role,
                      'section': section,
                      'subjects': [],
                      'attendance': {},
                      'details': {},
                    });

                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error: $e');
                  }
                }
              },
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
