import 'dart:async';

import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:isar/isar.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/transmission.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data.dart';
import 'package:stalker/location/position_fetcher.dart';
import 'package:stalker/logger/logger.dart';
import 'package:stalker/notification/stalker_notification_channel.dart';
import 'package:stalker/stalk/stalk_protocol.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/user_distance_from_stalker.dart';

class StalkTransmitter {
  static final Map<int, StalkTransmitter> _cache = {};
  final User target;
  final bool isInBackground;

  bool _isTransmitting = false;
  int _transmissionStopRequestCount = 0;
  LiveData<Transmission>? _currentTransmission;

  StalkTransmitter._(this.target, this.isInBackground);

  factory StalkTransmitter(User target, [bool isInBackground = false]) =>
      _cache[target.id] ??= StalkTransmitter._(target, isInBackground);

  Future<void> sendTransmission(User stalker) async {
    _startTransmission(stalker);
    return _maybeStopTransmissionWithDelay();
  }

  void interruptTransmission() async {
    final db = await Db.db;
    final transmissions = await db.transmissions
        .where()
        .targetIdEqualTo(target.id)
        .filter()
        .stateEqualTo(TransmissionState.started)
        .findAll();
    await db.writeTxn(() async {
      for (final transmission in transmissions) {
        transmission.state = TransmissionState.interrupted;
        await db.transmissions.put(transmission);
      }
    });
  }

  static void interruptAllTransmission() async {
    final db = await Db.db;
    final transmissions = await db.transmissions
        .filter()
        .stateEqualTo(TransmissionState.started)
        .findAll();
    await db.writeTxn(() async {
      for (final transmission in transmissions) {
        transmission.state = TransmissionState.interrupted;
        await db.transmissions.put(transmission);
      }
    });
  }

  void _startTransmission(User stalker) {
    if (_isTransmitting) {
      return;
    }

    PositionFetcher.position.addListener(_onLocationUpdate);
    PositionFetcher.startTracking();
    final transmission = Transmission()
      ..startTime = DateTime.now()
      ..state = TransmissionState.started
      ..targetId = target.id
      ..stalkerId = stalker.id;
    Db.db.then((db) async {
      await db.writeTxn(() => db.transmissions.put(transmission));
      _currentTransmission = LiveData(transmission)
        ..inCollection(db.transmissions);
    });
    _isTransmitting = true;

    if (isInBackground) {
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
    }
  }

  void _stopTransmission() {
    if (!_isTransmitting) {
      return;
    }

    PositionFetcher.position.removeListener(_onLocationUpdate);
    PositionFetcher.stopTracking();
    _isTransmitting = false;
    final transmission = _currentTransmission!.value!
      ..state = TransmissionState.stopped;
    _currentTransmission = null;
    Db.db.then((db) async {
      await db.writeTxn(() => db.transmissions.put(transmission));
    });

    slog('-------------Ended Transmission----------------');
    AndroidForegroundService.stopForeground(11);
    // TODO confirm with unread messages

    if (isInBackground) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: StalkerNotificationChannel.silentUnread.key,
          title: '${target.displayName} was watching you.',
          body: '${UserDistanceFromStalker.getDistanceFromUser(target)} away',
          actionType: ActionType.Default,
        ),
      );
    }
  }

  Future<void> _maybeStopTransmissionWithDelay() async {
    final stopRequestId = ++_transmissionStopRequestCount;
    return Future.delayed(const Duration(seconds: 20), () {
      if (stopRequestId == _transmissionStopRequestCount) {
        _stopTransmission();
      }
    });
  }

  void _onLocationUpdate() {
    if (_currentTransmission?.value?.state != TransmissionState.started) {
      _stopTransmission();
      return;
    }

    final position = PositionFetcher.position.value;
    if (position != null) {
      StalkProtocol().sendPosition(target, position);
      _storeLocation(position);
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
