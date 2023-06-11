import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stalker/logger/logger.dart';
import 'package:stalker/notification/stalker_notification_channel.dart';
import 'package:stalker/stalk/stalk_protocol.dart';
import 'package:stalker/stalker_app.dart';
import 'package:stalker/user/active_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.getToken().then(
        (value) => FirebaseMessaging.onMessage.listen(
          (message) {
            slog('[fcm] incoming -> ${message.data}');
            StalkProtocol().handleFcm(message);
          },
        ),
      );

  await StalkerNotificationChannel.initialize();

  runApp(const StalkerApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp();
  slog('[fcm-bg] incoming -> ${message.data}');
  await ActiveUser().load();
  StalkProtocol(true).handleFcm(message);
}
