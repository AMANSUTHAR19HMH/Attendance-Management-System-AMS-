import 'package:flutter/material.dart';

import 'splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => splash(),
        '/Welcome': (context) => Welcome(),
      },
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
