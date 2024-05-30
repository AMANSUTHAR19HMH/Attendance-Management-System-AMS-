import 'package:attendance_management_system_ams/screens/attendense_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'authntication/LoginScreen.dart';
import 'screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => splash(),
        '/Welcome': (context) => Welcome(),
        '/LoginScreen': (context) => LoginScreen(),
        // '/SignupScreen': (context) => SignupScreen(),
        '/AttendanceScreen': (context) => AttendanceScreen(),
      },
      // home:splash()
    );
  }
}

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attandance Management System'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Welcome to the app'),
      ),
    );
  }
}
