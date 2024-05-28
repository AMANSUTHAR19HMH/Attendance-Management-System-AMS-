import 'package:get/get.dart';

class Student {
  final int id;
  final String name;
  var isPresent = false.obs;

  Student({required this.id, required this.name});
}

class AttendanceController extends GetxController {
  var students = <Student>[
    Student(id: 1, name: 'Sam Smith'),
    Student(id: 2, name: 'Sam Smith'),
    Student(id: 3, name: 'Sam Smith'),
    Student(id: 4, name: 'Sam Smith'),
    Student(id: 5, name: 'Sam Smith'),
    Student(id: 6, name: 'Sam Smith'),
  ].obs;

  void toggleAttendance(int index) {
    students[index].isPresent.value = !students[index].isPresent.value;
  }

  void refreshAttendance() {
    for (var student in students) {
      student.isPresent.value = false;
    }
  }
}
