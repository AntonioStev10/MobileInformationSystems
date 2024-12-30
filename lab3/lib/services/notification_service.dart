import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> initialize() async {

    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission for notifications");
    }


    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print("Device token: $token");

      await sendTokenToServer(token);
    } else {
      print("Failed to retrieve device token.");
    }

    // Handle token refresh (if token is changed)
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("Token refreshed: $newToken");
      sendTokenToServer(newToken);  // Send the new token to your server
    });

    // Handle push notifications when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a message: ${message.notification?.title}");
      // Handle the message (e.g., show a local notification or update the UI)
    });
  }

  // Send the device token to your server
  Future<void> sendTokenToServer(String token) async {
    const String serverUrl = "https://your-backend-server.com/api/save-token";
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        print("Token sent to server successfully.");
      } else {
        print("Failed to send token to server: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending token to server: $e");
    }
  }
}
