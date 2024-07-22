import 'package:attendance_management_system_ams/screens/EventsScreen.dart';
import 'package:attendance_management_system_ams/screens/ManageStudentsScreen.dart';
import 'package:attendance_management_system_ams/screens/ViewAttendanceScreen.dart';
import 'package:attendance_management_system_ams/teachers/teachersprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const MarkAttendance(),
    ViewAttendanceScreen(),
    const PersonalInfo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Mark Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'View Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personal Info',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 253, 143, 0),
        onTap: _onItemTapped,
      ),
    );
  }
}

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({super.key});

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  final Map<String, Map<String, Map<String, int>>> attendanceMap =
      {}; // userId -> date -> subject -> attendance status
  final TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  String? selectedSubject;
  final List<String> subjects = [
    'Math',
    'Science',
    'History',
    'English'
  ]; // Example subjects

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration:
                        const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  hint: const Text('Select Subject'),
                  value: selectedSubject,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSubject = newValue;
                    });
                  },
                  items: subjects.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var userData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    var userId = snapshot.data!.docs[index].id;
                    var userName = userData['username'] ?? 'Unknown';
                    var userEmail = userData['email'] ?? 'No email';
                    var userPhone = userData['phone'] ?? 'No phone';

                    print('User ID: $userId');
                    print('User Name: $userName');

                    var attendanceData = attendanceMap[userId] ?? {};
                    var subjectData =
                        attendanceData[selectedDateAsString] ?? {};

                    return ListTile(
                      title: Text(userName),
                      subtitle: Text('$userEmail - $userPhone'),
                      trailing: DropdownButton<String>(
                        value: subjectData[selectedSubject] != null &&
                                subjectData[selectedSubject] == 1
                            ? 'Present'
                            : 'Absent',
                        items:
                            <String>['Present', 'Absent'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              subjectData[selectedSubject!] =
                                  newValue == 'Present' ? 1 : 0;
                              attendanceData[selectedDateAsString] =
                                  subjectData;
                              attendanceMap[userId] = attendanceData;
                            }
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveAttendance,
        child: const Icon(Icons.save),
      ),
    );
  }

  String get selectedDateAsString => selectedDate != null
      ? DateFormat('yyyy-MM-dd').format(selectedDate!)
      : '';

  void saveAttendance() async {
    final date = dateController.text.trim();

    if (date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the date')),
      );
      return;
    }

    if (selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subject')),
      );
      return;
    }

    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Check if attendance has already been marked for the selected subject on the selected date
      bool alreadyMarked = false;

      attendanceMap.forEach((userId, attendanceData) {
        var subjectData = attendanceData[date];
        if (subjectData != null && subjectData.containsKey(selectedSubject!)) {
          alreadyMarked = true;
          return;
        }
      });

      if (alreadyMarked) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Attendance already marked for this subject on $date')),
        );
        return;
      }

      attendanceMap.forEach((userId, attendanceData) {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        int status = attendanceData[date]?[selectedSubject!] ??
            1; // Assuming default is 'Present' = 1
        batch.update(userRef, {'attendance.$date.${selectedSubject!}': status});
      });

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance updated successfully')),
      );
    } catch (e) {
      print('Error updating attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update attendance')),
      );
    }
  }
}

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  DocumentReference teacherDoc =
      FirebaseFirestore.instance.collection('teachers').doc();
  @override
  Widget build(BuildContext context) {
    User? teacher = FirebaseAuth.instance.currentUser;

    if (teacher == null) {
      // No user is signed in
      return Scaffold(
        appBar: AppBar(
          title: Text('Teacher Profile'),
        ),
        body: Center(
          child: Text('No Teacher is currently signed in.'),
        ),
      );
    }
    String userId = teacher.uid;

    // Reference to the specific teacher document based on user ID
    DocumentReference teacherDoc =
        FirebaseFirestore.instance.collection('teachers').doc(userId);

    return Scaffold(
      body: Column(
        mainAxisSize:
            MainAxisSize.min, // Ensures the column doesn't expand unnecessarily
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: FutureBuilder<DocumentSnapshot>(
              future: teacherDoc.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No data found'));
                } else {
                  // Extract data from the document
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  String name = data['username'] ?? 'No Name';
                  String email = data['email'] ?? 'No Email';
                  String profilePictureURL =
                      data['profilePictureUrl'] ?? 'assets/default_profile.png';

                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(profilePictureURL),
                              radius: 30.0,
                            ),
                            SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: $name',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Email: $email',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20.0), // Adjusted height for spacing
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                _buildDashboardItem(
                  'Events',
                  'assets/CustomIcons/Event.png',
                  const Color.fromARGB(212, 255, 153, 0),
                  () {
                    Get.to(EventsScreen());
                  },
                ),
                _buildDashboardItem(
                  'Manage Students',
                  'assets/CustomIcons/managestudents.png',
                  const Color.fromARGB(255, 57, 176, 39),
                  () {
                    Get.to(const ManageStudentsScreen());
                  },
                ),
                _buildDashboardItem(
                  'Teachers Profile',
                  'assets/CustomIcons/profile.png',
                  const Color.fromARGB(206, 61, 19, 233),
                  () {
                    Get.to(const teachersprofile());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(
      String title, String icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        margin: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(icon),
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
