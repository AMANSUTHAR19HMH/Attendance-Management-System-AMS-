import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class splash extends StatefulWidget {
  @override
  State<splash> createState() => _SplashState();
}

class _SplashState extends State<splash> {
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    var duration = Duration(milliseconds: 2100);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacementNamed(context, '/Welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: content(),
    );
  }

  Widget content() {
    return Center(
      child: Container(
        color: Colors.black,
        child: Lottie.asset(
          'assets/D.json',
          // Ensure you have your Lottie file in the assets directory
          width: 200, // Adjust width as needed
          height: 200, // Adjust height as needed
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
