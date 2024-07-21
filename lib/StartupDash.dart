import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'authntication/AdminLoginScreen.dart';
import 'authntication/LoginScreen.dart';
import 'authntication/TeacherLogin.dart';

class LoginDash extends StatefulWidget {
  const LoginDash({Key? key}) : super(key: key);

  @override
  State<LoginDash> createState() => _LoginDashState();
}

class _LoginDashState extends State<LoginDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.purple.withOpacity(1.0),
                    BlendMode.softLight,
                  ),
                  image: AssetImage(
                    "assets/CustomIcons/Dashboard.jpg",
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "AMS",
                style: GoogleFonts.lato(
                  fontSize: 40,
                  color: Color.fromARGB(255, 168, 122, 35),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        top: 50,
                        bottom: 20,
                      ),
                      children: [
                        itemDashboard('ADMIN', "assets/CustomIcons/admins.png",
                            Colors.blueAccent),
                        itemDashboard('USER', "assets/CustomIcons/Student.png",
                            Colors.green),
                        itemDashboard(
                            'TEACHER',
                            "assets/CustomIcons/teacher.png",
                            Colors.yellowAccent.shade400),
                        itemDashboard('EXIT', "assets/CustomIcons/exit.png",
                            Colors.orangeAccent),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget itemDashboard(String title, String iconData, Color background) {
  return GestureDetector(
    onTap: () {
      if (title == 'USER') {
        Get.to(StudentLoginScreen());
      } else if (title == 'ADMIN') {
        Get.to(AdminLoginScreen());
      } else if (title == 'TEACHER') {
        Get.to(TeacherLoginScreen());
      } else if (title == 'EXIT') {
        exit(0);
      }
    },
    child: Container(
      margin: EdgeInsets.all(16.0), // Adjust margin for spacing
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Color.fromRGBO(20, 30, 40, 0.5),
            spreadRadius: 2,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image(
              image: AssetImage(iconData),
              width: 60,
              height: 60,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 18), // Adjust text style as needed
          ),
        ],
      ),
    ),
  );
}
