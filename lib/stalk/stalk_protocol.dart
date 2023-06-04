import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/stalk_target.dart';
import 'package:stalker/location/location_fetcher.dart';

enum StalkAction {
  stalkRequest(1),
  stalkRequestAck(2),
  locationShare(3);

  final int code;

  const StalkAction(this.code);

  factory StalkAction.fromCode(int code) {
    if (code > values.length) {
      throw 'Unsupported';
    }
    return StalkAction.values[code - 1];
  }
}

class StalkMessage {
  final StalkAction action;
  final StalkTarget sender;
  final Map<String, dynamic> data;

  StalkMessage({
    required this.action,
    required this.sender,
    required this.data,
  });
}

class StalkProtocol {
  static final StreamController<StalkMessage> _messageStreamController =
      StreamController<StalkMessage>.broadcast();

  static final Stream<StalkMessage> messages = _messageStreamController.stream;

  StalkProtocol();

  void handleFcm(RemoteMessage message) async {
    print('[fcm] ${message.data}');
    final db = await Db.db;
    final sender = message.data['f'];
    final targets =
        await db.stalkTargets.where().tokenEqualTo(sender).findAll();
    if (targets.isEmpty) {
      // FIXME Spam feature
      return;
    }
    // FIXME Filter targets with permission.
    final stalkAction = StalkAction.fromCode(int.parse(message.data['c']));
    _handleStalkMessage(StalkMessage(
      action: stalkAction,
      sender: targets.first,
      data: message.data,
    ));
  }

  void _handleStalkMessage(StalkMessage message) {
    _messageStreamController.sink.add(message);
    switch (message.action) {
      case StalkAction.stalkRequest:
        sendStalkMessage(message.sender.token!, StalkAction.stalkRequestAck);
        listener() {
          sendStalkMessage(
            message.sender.token!,
            StalkAction.locationShare,
            {'position': _mappedPosition},
          );
        }
        print('Tracking location...');
        LocationFetcher.trackLocation();
        LocationFetcher.currentPosition.addListener(listener);
        Future.delayed(const Duration(seconds: 10), () {
          LocationFetcher.currentPosition.removeListener(listener);
          LocationFetcher.stopTracking();
          print('Tracking stopped');
        });
        return;
      case StalkAction.stalkRequestAck:
        return;
      case StalkAction.locationShare:
        _storeLocation(message);
        break;
    }
  }

  Future<bool> sendStalkMessage(String token, StalkAction action,
      [Map<String, dynamic> data = const {}]) {
    return _sendFcm(
      token,
      <String, dynamic>{
        'c': action.code,
        if (data.isNotEmpty) 'd': data,
      },
    );
  }

  Future<bool> _sendFcm(String token, Map<String, dynamic> data) async {
    final sender = await FirebaseMessaging.instance.getToken();
    final json = jsonEncode(
      <String, dynamic>{
        'priority': 'high',
        'data': <String, dynamic>{...data, 'f': sender!},
        "to": token,
      },
    );
    final result = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAO_390dw:APA91bHmann0MjxGVuKX6NBXQgPQbXUX66i67Au7uOaCAkVBGwRGk0SRo6XyIuzcyPBLO3rXNx7qWJaH08B5E6fSaPB-JERvpevgK6cZPYis6Qbeb-1Uc8eAH4__PIjBnsPwlJXC6wC6',
      },
      body: json,
    );

    print('${result.statusCode}:${result.body}');
    if (result.statusCode == 200) {
      return true;
    }
    return false;
  }

  void _storeLocation(StalkMessage message) async {
    final positionData = jsonDecode(message.data['d'])['position'];
    final target = message.sender;
    target.lastLocationLatitude = positionData['la'];
    target.lastLocationLongitude = positionData['lo'];
    target.lastLocationTimestamp =
        DateTime.fromMillisecondsSinceEpoch(positionData['t']);
    target.lastLocationAccuracy = positionData['a'];

    final db = await Db.db;
    db.writeTxn(() => db.stalkTargets.put(target));
  }

  Map<String, dynamic>? get _mappedPosition {
    final position = LocationFetcher.currentPosition.value;
    if (position == null) {
      return null;
    }
    return {
      'la': position.latitude,
      'lo': position.longitude,
      't': (position.timestamp ?? DateTime.now()).millisecondsSinceEpoch,
      'a': position.accuracy,
    };
  }
}
