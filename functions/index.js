const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendAttendanceNotification = functions.firestore
  .document("attendance/{userId}")
  .onWrite(async (change, context) => {
    const userId = context.params.userId;
    const after = change.after.data();
    const status = after.isPresent ? "present" : "absent";

    const userDoc = await admin.firestore().collection("users").doc(userId).get();
    const userData = userDoc.data();
    const fcmToken = userData.fcmToken;

    const payload = {
      notification: {
        title: "Attendance Update",
        body: `You are marked as ${status}.`,
      },
    };

    try {
      await admin.messaging().sendToDevice(fcmToken, payload);
      console.log("Notification sent successfully");
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });
