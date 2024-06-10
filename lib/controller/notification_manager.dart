// import 'package:firebase_messaging/firebase_messaging.dart';

// Function to send FCM notification
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> sendNotification(String fcmToken, String message) async {
  try {
    // Construct FCM message
    final notification = {
      'notification': {
        'title': 'Attendance Update',
        'body': message,
      },
      'token': fcmToken,
    };

    // Send FCM message
    // await FirebaseMessaging.instance.send(notification);
  } catch (e) {
    print('Error sending notification: $e');
  }
}
