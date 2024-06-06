import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

// Saves Profile Data here//
final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  // Method for key value pairing //
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage
        .ref()
        .child(childName)
        .child('id'); // Unique Id given to the User //
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadurl = await snapshot.ref.getDownloadURL();
    return downloadurl;
  }

  // Method for Saving values in Firebase //

  Future<String> saveData({
    required Uint8List file,
  }) async {
    String resp = "Some Error Occurred";
    try {
      String imageurl = await uploadImageToStorage('profileImage', file);
      await _firestore.collection('userprofile').add({
        'ImageLink': imageurl,
      });
      resp = 'success';
    } catch (err) {}
    return resp;
  }
}
