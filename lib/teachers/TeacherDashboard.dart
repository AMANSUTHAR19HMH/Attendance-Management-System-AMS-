import 'package:flutter/material.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ClassSchedule(),
    MarkAttendance(),
    ViewAttendance(),
    PersonalInfo(),
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Class Schedule',
          ),
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class ClassSchedule extends StatelessWidget {
  const ClassSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Class Schedule',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class MarkAttendance extends StatelessWidget {
  const MarkAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Mark Attendance',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ViewAttendance extends StatelessWidget {
  const ViewAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'View Attendance',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Personal Info',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
