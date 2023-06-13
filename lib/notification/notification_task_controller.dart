import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/map/map_page.dart';
import 'package:stalker/notification/stalker_notification_channel.dart';
import 'package:stalker/stalk/stalk_transmitter.dart';
import 'package:stalker/stalker_app.dart';

class NotificationTaskController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    final navigatorState = StalkerApp.navigatorKey.currentState;

    if (receivedAction.channelKey == StalkerNotificationChannel.unread.key) {
      navigatorState?.popUntil((route) => route.isFirst);
      // TODO if unread single user chat -> go to chat with user
    } else if (receivedAction.channelKey ==
        StalkerNotificationChannel.stalk.key) {
      final db = await Db.db;
      final id = int.parse(receivedAction.payload!['id']!);
      var user = (await db.users.get(id))!;

      if (receivedAction.buttonKeyPressed == 'stop-stalk') {
        user = await db.writeTxn(() async {
          final u =
              await db.users.get(int.parse(receivedAction.payload!['id']!));
          u!.isEnabled = false;
          db.users.put(u);
          return u;
        });
        StalkTransmitter(user).interruptTransmission();
      }

      // TODO if already in MapPage, do nothing... Named routes?
      navigatorState?.popUntil((route) => route.isFirst);
      navigatorState?.push(
        MaterialPageRoute(builder: (c) => MapPage(user: user)),
      );
    }
  }
}
