import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
}

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
