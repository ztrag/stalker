import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/location/position_fetcher.dart';
import 'package:stalker/notification/stalker_notification_channel.dart';
import 'package:stalker/stalk/stalk_protocol.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/user_distance_from_stalker.dart';

class StalkTransmitter {
  Future<void> sendTransmission(User target,
      [bool isInBackground = false]) async {
    if (isInBackground) {
      return _sendTransmissionWithForegroundNotification(target);
    }
    return _sendTransmission(target);
  }

  Future<void> _sendTransmission(User target) {
    listener() {
      final position = PositionFetcher.position.value;
      if (position != null) {
        StalkProtocol().sendPosition(target, position);
        _storeLocation(position);
      }
    }

    PositionFetcher.position.addListener(listener);
    PositionFetcher.startTracking();
    return Future.delayed(const Duration(seconds: 10), () {
      PositionFetcher.position.removeListener(listener);
      PositionFetcher.stopTracking();
    });
  }

  Future<void> _sendTransmissionWithForegroundNotification<T>(
      User target) async {
    AndroidForegroundService.startAndroidForegroundService(
      content: NotificationContent(
        id: 11,
        channelKey: StalkerNotificationChannel.stalk.key,
        title: '${target.displayName} is watching you...',
        body: '${UserDistanceFromStalker.getDistanceFromUser(target)} away',
        payload: {'id': '${target.id}'},
      ),
      foregroundServiceType: ForegroundServiceType.location,
      foregroundStartMode: ForegroundStartMode.notStick,
      actionButtons: [
        NotificationActionButton(key: 'stop-stalk', label: 'Make it stop'),
      ],
    );

    try {
      final result = await _sendTransmission(target);
      AndroidForegroundService.stopForeground(11);
      // TODO confirm with unread messages
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: StalkerNotificationChannel.silentUnread.key,
          title: '${target.displayName} was watching you.',
          body: '${UserDistanceFromStalker.getDistanceFromUser(target)} away',
          actionType: ActionType.Default,
        ),
      );
      return result;
    } catch (_) {
      AndroidForegroundService.stopForeground(11);
      rethrow;
    }
  }

  void _storeLocation(Position position) async {
    final db = await Db.db;
    db.writeTxn(() async {
      final saved = ActiveUser().value!;
      saved.lastLocationLatitude = position.latitude;
      saved.lastLocationLongitude = position.longitude;
      saved.lastLocationTimestamp = position.timestamp;
      saved.lastLocationAccuracy = position.accuracy;
      return db.users.put(saved);
    });
  }
}
