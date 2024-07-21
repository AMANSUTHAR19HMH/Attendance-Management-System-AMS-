import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class ManageAttendanceScreen extends StatefulWidget {
  const ManageAttendanceScreen({super.key});

  @override
  _ManageAttendanceScreenState createState() => _ManageAttendanceScreenState();
}

class _ManageAttendanceScreenState extends State<ManageAttendanceScreen> {
  final TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  String? selectedSubject;
  final List<String> subjects = ['Math', 'Science', 'History', 'English'];

  get date_ => null; // Example subjects

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Attendance'),
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
                    decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
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
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                    var userData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    var userId = snapshot.data!.docs[index].id;
                    var userName = userData['username'];
                    var userEmail = userData['email'];

                    return ListTile(
                      title: Text(userName),
                      subtitle: Text(userEmail),
                      trailing: DropdownButton<String>(
                        value: _getAttendanceStatus(userId),
                        items: <String>['Present', 'Absent']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _updateAttendance(userId, newValue);
                          }
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

  String get selectedDateAsString =>
      selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : '';

  String _getAttendanceStatus(String userId) {
    final date = selectedDateAsString;
    final subject = selectedSubject;
    if (date.isNotEmpty && subject != null) {
      // Fetch attendance status from Firestore
      // Placeholder logic: Replace with actual Firestore fetch
      return 'Absent'; // Default status
    }
    return 'Absent'; // Default status if no date/subject selected
  }

  void _updateAttendance(String userId, String status) async {
    final date = selectedDateAsString;
    final subject = selectedSubject;

    if (date.isEmpty || subject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and subject')),
      );
      return;
    }

    try {
      // Update the attendance data in Firestore
      DocumentReference attendanceRef = FirebaseFirestore.instance.collection('attendance').doc('$date_$subject');
      DocumentSnapshot attendanceSnapshot = await attendanceRef.get();

      Map<String, dynamic> userAttendance = attendanceSnapshot.exists ? attendanceSnapshot.data() as Map<String, dynamic> : {};
      userAttendance[userId] = status == 'Present' ? 1 : 0;

      await attendanceRef.set(userAttendance);
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

    // The save functionality might not be needed if updating attendance in real-time
  }
}
