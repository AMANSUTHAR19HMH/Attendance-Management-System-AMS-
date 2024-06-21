import 'package:attendance_management_system_ams/teachers/TeacherDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  TeacherLoginScreenState createState() => TeacherLoginScreenState();
}

class TeacherLoginScreenState extends State<TeacherLoginScreen> {
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _teacherLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      // Check if the logged-in user is a teacher
      DocumentReference teacherDoc = FirebaseFirestore.instance
          .collection('teachers') // Ensure this matches your Firestore collection name
          .doc(userCredential.user!.uid);

      DocumentSnapshot docSnapshot = await teacherDoc.get();

      if (!docSnapshot.exists) {
        throw FirebaseAuthException(
            code: 'Teacher-not-found',
            message: 'No teacher found for this email.');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teacher login successful')),
      );

      // Navigate to the teacher's dashboard after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TeacherDashboard()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teacher login failed: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xffF4EEF2),
              Color(0xffF4EEF2),
              Color(0xffE3EDF5),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(height: size.height * 0.03),
              const Text(
                "Teachers",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 37,
                  color: Color(0xff353047),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Welcome to Zidio Development \n Attendance App",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 27, color: Color(0xff6F6B7A), height: 1.2),
              ),
              SizedBox(height: size.height * 0.04),
              // Email and Password TextFields
              _reusableTextField(
                  "Enter Email", Icons.email_outlined, false, emailTextController),
              _reusableTextField(
                  "Enter Password", Icons.lock_outline, true, passwordTextController),
              SizedBox(height: size.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    // Sign In Button
                    InkWell(
                      onTap: _teacherLogin,
                      child: Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        margin: const EdgeInsets.only(top: 40),
                        decoration: BoxDecoration(
                          color: const Color(0xffFD6B68),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable TextField Widget
  Padding _reusableTextField(
      String text, IconData icon, bool isPasswordType, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPasswordType,
        enableSuggestions: !isPasswordType,
        autocorrect: !isPasswordType,
        cursorColor: Colors.black26,
        style: TextStyle(color: Colors.black26.withOpacity(0.9)),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black26),
          labelText: text,
          labelStyle: TextStyle(color: Colors.black26.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
        ),
        keyboardType:
        isPasswordType ? TextInputType.visiblePassword : TextInputType.emailAddress,
      ),
    );
  }
}
