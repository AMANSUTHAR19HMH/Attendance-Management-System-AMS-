import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTeachers extends StatefulWidget {
  final String userId;
  final DocumentSnapshot user;

  const EditTeachers({required this.userId, required this.user, super.key});

  @override
  _EditTeachersState createState() => _EditTeachersState();
}

class _EditTeachersState extends State<EditTeachers> {
  late TextEditingController emailController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.user['email']);
    usernameController = TextEditingController(text: widget.user['username']);
  }

  Future<void> _updateUser() async {
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.userId)
        .update({
      'email': emailController.text,
      'username': usernameController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Teacher updated successfully')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Teacher')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUser,
              child: const Text('Update User'),
            ),
          ],
        ),
      ),
    );
  }
}
