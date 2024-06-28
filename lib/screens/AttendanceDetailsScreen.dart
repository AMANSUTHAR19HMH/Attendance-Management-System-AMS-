// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class AttendanceDetailsScreen extends StatefulWidget {
//   final String userId;
//
//   AttendanceDetailsScreen({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   _AttendanceDetailsScreenState createState() =>
//       _AttendanceDetailsScreenState();
// }
//
// class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {
//   late Stream<DocumentSnapshot> userStream;
//   late List<String> studentsList = [];
//
//   final TextEditingController dateController = TextEditingController();
//   String status = 'Present'; // Default status
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch the user's information and attendance data from Firestore
//     userStream = FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.userId)
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manage Attendance for ${widget.userId}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: StreamBuilder<DocumentSnapshot>(
//           stream: userStream,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//
//             if (!snapshot.hasData || snapshot.data!.data() == null) {
//               return Center(child: Text('No data found.'));
//             }
//
//             var userData = snapshot.data!.data() as Map<String, dynamic>;
//             var userName = userData['fullName'];
//             var userEmail = userData['email'];
//             var userPhone = userData['phone'];
//             var attendanceData = userData['attendance'] ?? {};
//
//             // Extract all student names
//             studentsList = attendanceData.keys.toList();
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Student Details:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text('Name: $userName'),
//                 Text('Email: $userEmail'),
//                 Text('Phone: $userPhone'),
//                 SizedBox(height: 20),
//                 Text(
//                   'Manage Attendance:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: dateController,
//                         decoration:
//                             InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     DropdownButton<String>(
//                       value: status,
//                       onChanged: (value) {
//                         setState(() {
//                           status = value!;
//                         });
//                       },
//                       items: <String>['Present', 'Absent']
//                           .map<DropdownMenuItem<String>>(
//                             (String value) => DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final date = dateController.text.trim();
//
//                     if (date.isNotEmpty) {
//                       try {
//                         // Update attendance for all students for the selected date
//                         studentsList.forEach((studentName) async {
//                           await FirebaseFirestore.instance
//                               .collection('users')
//                               .doc(widget.userId)
//                               .update({
//                             'attendance.$date.$studentName': status,
//                           });
//                         });
//
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                               content: Text(
//                                   'Attendance updated successfully for $date')),
//                         );
//                       } catch (e) {
//                         print('Error updating attendance: $e');
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                               content: Text('Failed to update attendance')),
//                         );
//                       }
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Please enter a valid date')),
//                       );
//                     }
//                   },
//                   child: Text('Update Attendance'),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
