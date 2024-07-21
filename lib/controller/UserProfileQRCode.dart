import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserProfileQRCode extends StatefulWidget {
  final String userId;

  const UserProfileQRCode({super.key, required this.userId});

  @override
  _UserProfileQRCodeState createState() => _UserProfileQRCodeState();
}

class _UserProfileQRCodeState extends State<UserProfileQRCode> {
  Map<String, dynamic> _profileData = {};

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      // Fetch the user profile from Firestore using the provided userId
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      setState(() {
        _profileData = userProfile.data() as Map<String, dynamic>;
      });
    } catch (error) {
      print('Error fetching user profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format profile data into a string (replace with your own formatting)
    String profileString = 'Name: ${_profileData['fullName']}\n'
        'Email: ${_profileData['email']}\n'
        'Phone: ${_profileData['phone']}';
    // You can add more profile fields as needed

    return Scaffold(
      body: Center(
        child: FutureBuilder<Uint8List?>(
          future: generateQRCode(profileString),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.memory(
                    snapshot.data!,
                    width: 200, // Adjust the width as needed
                    height: 200, // Adjust the height as needed
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Scan this QR code to view user profile details.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              );
            } else {
              return const Text('No QR code data available');
            }
          },
        ),
      ),
    );
  }

  Future<Uint8List?> generateQRCode(String data) async {
    // Generate QR code as an image
    QrPainter painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      color: Colors.black,
      emptyColor: Colors.white,
    );
    ByteData? byteData = await painter.toImageData(200);
    return byteData?.buffer.asUint8List();
  }
}
