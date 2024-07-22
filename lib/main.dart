import 'package:attendance_management_system_ams/Dashboard/StudentDashboard.dart';
import 'package:attendance_management_system_ams/StartupDash.dart';
import 'package:attendance_management_system_ams/authntication/SignupScreen.dart';
import 'package:attendance_management_system_ams/authntication/TeacherLogin.dart';
import 'package:attendance_management_system_ams/screens/attendense_screen.dart';
import 'package:attendance_management_system_ams/teachers/teachersprofile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'authntication/LoginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginDash(),
        '/LoginScreen': (context) => const StudentLoginScreen(),
        '/SignupScreen': (context) => const SignupScreen(),
        '/Dashboard': (context) => const StudentDashboardScreen(),
        '/profile': (context) => const teachersprofile(),
        '/AttendanceScreen': (context) => AttendanceScreen(),
        '/Teacherlogin': (context) => TeacherLoginScreen(),
      },
      // home:splash()
    );
  }
}
