import 'package:attendance_management_system_ams/controller/attendense_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceScreen extends StatelessWidget {
  final AttendanceController attendanceController =
      Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance List', style: GoogleFonts.montserrat()),
        actions: [
          TextButton(
            onPressed: () {
              attendanceController.refreshAttendance();
            },
            child: Text(
              'Refresh',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: 'Section',
              items: <String>['Section'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
          Expanded(
            child: Obx(() {
              return GridView.builder(
                padding: const EdgeInsets.all(4.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: 60,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 10,
                ),
                itemCount: attendanceController.students.length,
                itemBuilder: (context, index) {
                  final student = attendanceController.students[index];
                  return GestureDetector(
                    onTap: () {
                      attendanceController.toggleAttendance(index);
                    },
                    child: Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          color: student.isPresent.value
                              ? Colors.black54
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${student.id}. ${student.name}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18.0, // Increase font size
                                    color: student.isPresent.value
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Transform.scale(
                                  scale: 0.8, 
                                  child: Checkbox(
                                    value: student.isPresent.value,
                                    onChanged: (value) {
                                      attendanceController
                                          .toggleAttendance(index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
