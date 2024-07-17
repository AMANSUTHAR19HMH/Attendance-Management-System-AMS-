import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firstoreprofile/ProfileService.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  Map<String, dynamic> _profileData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    // Get the current user ID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      Map<String, dynamic> profileData =
          await _profileService.getUserProfile(userId);
      setState(() {
        _profileData = profileData;
      });
    } else {
      print('User not logged in');
      // Handle the case when the user is not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            if (_profileData.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfilePicture(), // Display profile picture
                  const SizedBox(height: 20.0),
                  Text('Name: ${_profileData['fullName']}'),
                  Text('Email: ${_profileData['email']}'),
                  Text('Phone: ${_profileData['phone']}'),
                  Text('Address: ${_profileData['address']}'),
                  Text('Department: ${_profileData['department']}'),
                  Text('Father\'s Name: ${_profileData['fatherName']}'),
                  Text('Mother\'s Name: ${_profileData['motherName']}'),
                  // Add more fields as needed
                ],
              )
            else
              const Text('Loading profile...'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    // Use the profile picture URL from _profileData if available
    String? profilePictureUrl = _profileData['profilePictureUrl'];
    if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 50.0,
        backgroundImage: NetworkImage(profilePictureUrl),
      );
    } else {
      // If no profile picture URL is available, display a default icon
      return const CircleAvatar(
        radius: 50.0,
        child: Icon(Icons.person, size: 50.0),
      );
    }
  }
}
