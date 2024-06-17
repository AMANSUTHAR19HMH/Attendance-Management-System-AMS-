import 'dart:io';

import 'package:attendance_management_system_ams/authntication/AdminLoginScreen.dart';
import 'package:attendance_management_system_ams/authntication/LoginScreen.dart';
import 'package:attendance_management_system_ams/authntication/TeacherLogin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LoginDash extends StatefulWidget {
  const LoginDash({Key? key}) : super(key: key);

  @override
  State<LoginDash> createState() => _LoginDashState();
}

class _LoginDashState extends State<LoginDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(255, 155, 8, 247),
        child: Center(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(
                            Colors.purple.withOpacity(1.0),
                            BlendMode.softLight),
                        image: AssetImage(
                          "assets/CustomIcons/Dashboard.jpg",
                        ))),
              ),
              Center(
                child: Text(
                  "Welcome To AMS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              // Main Dashboard Components for navigation ///
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 500,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,

                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                      top: 50,
                      bottom: 20,
                    ),
                    crossAxisSpacing: 50,

                    mainAxisSpacing: 40,
                    // DashBoard Icons
                    children: [
                      itemDashboard('ADMIN', "assets/CustomIcons/admins.png",
                          Colors.blueAccent),
                      itemDashboard('USER', "assets/CustomIcons/Student.png",
                          Colors.green),
                      // QR Attendance icon
                      itemDashboard('TEACHER', "assets/CustomIcons/teacher.png",
                          Colors.yellowAccent.shade400),
                      itemDashboard('EXIT', "assets/CustomIcons/exit.png",
                          Colors.orangeAccent),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget itemDashboard(String title, String iconData, Color background) {
  return GestureDetector(
    onTap: () {
      if (title == 'USER') {
        Get.to(LoginScreen());
      } else if (title == 'ADMIN') {
        Get.to(AdminLoginScreen());
      } else if (title == 'TEACHER') {
        Get.to(TeacherLoginScreen());
      } else if (title == 'EXIT') {
        exit(0);
      }
    },
    child: Container(
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
          ),
        ],
      ),
    ),
  );
}
