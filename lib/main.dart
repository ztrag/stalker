import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stalker/stalk/stalk_protocol.dart';
import 'package:stalker/stalker_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.getToken().then(
        (value) => FirebaseMessaging.onMessage.listen(
          (message) => StalkProtocol().handleFcm(message),
        ),
      );

  runApp(const StalkerApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId} ${message.data}");
}
