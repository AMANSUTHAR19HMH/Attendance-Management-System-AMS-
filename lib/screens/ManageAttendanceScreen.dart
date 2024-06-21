import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class ManageAttendanceScreen extends StatefulWidget {
  @override
  _ManageAttendanceScreenState createState() => _ManageAttendanceScreenState();
}

class _ManageAttendanceScreenState extends State<ManageAttendanceScreen> {
  final Map<String, Map<String, Map<String, int>>> attendanceMap = {}; // userId -> date -> subject -> attendance status
  final TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  String? selectedSubject;
  final List<String> subjects = ['Math', 'Science', 'History', 'English']; // Example subjects

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Attendance'),
      ),
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
                    decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
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
                          dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                  ),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  hint: Text('Select Subject'),
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
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No users found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var userData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    var userId = snapshot.data!.docs[index].id;
                    var userName = userData['fullName'];
                    var userEmail = userData['email'];
                    var userPhone = userData['phone'];

                    var attendanceData = attendanceMap[userId] ?? {};
                    var subjectData = attendanceData[selectedDateAsString] ?? {};

                    return ListTile(
                      title: Text(userName),
                      subtitle: Text('$userEmail - $userPhone'),
                      trailing: DropdownButton<String>(
                        value: subjectData[selectedSubject] != null && subjectData[selectedSubject] == 1 ? 'Present' : 'Absent',
                        items: <String>['Present', 'Absent']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              subjectData[selectedSubject!] = newValue == 'Present' ? 1 : 0;
                              attendanceData[selectedDateAsString] = subjectData;
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
        child: Icon(Icons.save),
      ),
    );
  }

  String get selectedDateAsString => selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : '';

  void saveAttendance() async {
    final date = dateController.text.trim();

    if (date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the date')),
      );
      return;
    }

    if (selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a subject')),
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
          SnackBar(content: Text('Attendance already marked for this subject on $date')),
        );
        return;
      }

      attendanceMap.forEach((userId, attendanceData) {
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);
        int status = attendanceData[date]![selectedSubject!] ?? 1; // Assuming default is 'Present' = 1
        batch.update(userRef, {'attendance.$date.${selectedSubject!}': status});
      });

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance updated successfully')),
      );
    } catch (e) {
      print('Error updating attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update attendance')),
      );
    }
  }
}
