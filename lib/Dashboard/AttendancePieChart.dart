// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import '../controller/attendense_controller.dart'; // Adjust the path as per your project structure

// class AttendancePieChart extends StatelessWidget {
//   final List<AttendanceData> attendanceData;

//   AttendancePieChart({required this.attendanceData});

//   @override
//   Widget build(BuildContext context) {
//     List<charts.Series<AttendanceData, String>> series = [
//       charts.Series(
//         id: 'Attendance',
//         data: attendanceData,
//         domainFn: (AttendanceData attendance, _) => attendance.fullName,
//         measureFn: (AttendanceData attendance, _) => 1, // Placeholder for measure function
//         labelAccessorFn: (AttendanceData attendance, _) => '${attendance.fullName}',
//       ),
//     ];

//     return charts.PieChart(
//       series,
//       animate: true,
//       animationDuration: Duration(milliseconds: 500),
//       defaultRenderer: charts.ArcRendererConfig(
//         arcWidth: 60,
//         arcRendererDecorators: [
//           charts.ArcLabelDecorator(
//             labelPosition: charts.ArcLabelPosition.auto,
//           ),
//         ],
//       ),
//     );
//   }
// }
