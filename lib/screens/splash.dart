import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _SplashState();
}

class _SplashState extends State<splash> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    var duration = const Duration(milliseconds: 2300);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacementNamed(context, '/LoginScreen');
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
          'assets/logo/D.json',
          // Ensure you have your Lottie file in the assets directory
          width: 500, // Adjust width as needed
          height: 500, // Adjust height as needed
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
