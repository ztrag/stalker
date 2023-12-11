import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';

enum StalkerNotificationChannel {
  stalk(
    'stalk',
    'Stalk',
    'Shows when a stalker is watching you.',
  ),
  unread(
    'unread',
    'Incoming Messages',
    'Shows unread messages from all contacts.',
  ),
  silentUnread(
    'silent-unread',
    'Recent Stalks',
    'Shows recent stalk sessions performed over background.',
  );

  final String key;
  final String name;
  final String description;

  const StalkerNotificationChannel(this.key, this.name, this.description);

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      'resource://mipmap/ic_notification_stalk',
      [
        NotificationChannel(
          channelKey: StalkerNotificationChannel.stalk.key,
          channelName: StalkerNotificationChannel.stalk.name,
          channelDescription: StalkerNotificationChannel.stalk.description,
          playSound: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelKey: StalkerNotificationChannel.unread.key,
          channelName: StalkerNotificationChannel.unread.name,
          channelDescription: StalkerNotificationChannel.unread.description,
          playSound: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelKey: StalkerNotificationChannel.silentUnread.key,
          channelName: StalkerNotificationChannel.silentUnread.name,
          channelDescription:
              StalkerNotificationChannel.silentUnread.description,
          playSound: false,
          enableVibration: false,
        ),
      ],
      debug: kDebugMode,
    );
  }
}
