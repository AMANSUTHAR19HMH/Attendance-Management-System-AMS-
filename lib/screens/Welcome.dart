import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attandance management system'),
      ),
      body: Center(
        child: Text(
          'Welcome to the app',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}