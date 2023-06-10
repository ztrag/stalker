import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/stalk/stalk_message_hub.dart';
import 'package:stalker/stalk/stalk_transmitter.dart';
import 'package:stalker/user/active_user.dart';

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
  final User sender;
  final User target;
  final Map<String, dynamic> data;

  StalkMessage({
    required this.action,
    required this.sender,
    required this.target,
    required this.data,
  });
}

class StalkProtocol {
  static final StreamController<StalkMessage> _messageStreamController =
      StreamController<StalkMessage>.broadcast();

  static final Stream<StalkMessage> messages = _messageStreamController.stream;

  StalkProtocol();

  void handleFcm(RemoteMessage message) async {
    final db = await Db.db;
    final sender = message.data['f'];
    final users = await db.users.where().tokenEqualTo(sender).findAll();
    if (users.isEmpty) {
      // FIXME Spam feature
      return;
    }
    // FIXME Filter targets with permission.
    final stalkAction = StalkAction.fromCode(int.parse(message.data['c']));
    _handleStalkMessage(StalkMessage(
      action: stalkAction,
      sender: users.last,
      target: ActiveUser().value!,
      data: message.data,
    ));
  }

  void _handleStalkMessage(StalkMessage message) async {
    _streamMessageToUi(message);
    switch (message.action) {
      case StalkAction.stalkRequest:
        if (!message.sender.isEnabled) {
          return;
        }

        await ActiveUser().load();
        if (!ActiveUser().value!.isEnabled) {
          return;
        }

        sendMessage(message.sender, StalkAction.stalkRequestAck);
        StalkTransmitter().sendTransmission(message.sender);
        return;
      case StalkAction.stalkRequestAck:
        return;
      case StalkAction.locationShare:
        _storeLocation(message);
        break;
    }
  }

  Future<bool> sendMessage(
    User target,
    StalkAction action, [
    Map<String, dynamic> data = const {},
  ]) {
    _streamMessageToUi(
      StalkMessage(
        action: action,
        sender: ActiveUser().value!,
        target: target,
        data: data,
      ),
    );
    return _sendFcm(
      target.token!,
      <String, dynamic>{
        'c': action.code,
        if (data.isNotEmpty) 'd': data,
      },
    );
  }

  Future<bool> sendPosition(User target, Position position) {
    return sendMessage(
      target,
      StalkAction.locationShare,
      {'position': _getMappedPosition(position)},
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

    if (result.statusCode == 200) {
      return true;
    }
    return false;
  }

  void _storeLocation(StalkMessage message) async {
    final positionData = jsonDecode(message.data['d'])['position'];
    final target = message.sender;

    final db = await Db.db;
    db.writeTxn(() async {
      final saved = await db.users.get(target.id);
      saved!.lastLocationLatitude = positionData['la'];
      saved.lastLocationLongitude = positionData['lo'];
      saved.lastLocationTimestamp =
          DateTime.fromMillisecondsSinceEpoch(positionData['t']);
      saved.lastLocationAccuracy = positionData['a'];
      return db.users.put(saved);
    });
  }

  Map<String, dynamic>? _getMappedPosition(Position? position) {
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

  void _streamMessageToUi(StalkMessage message) {
    StalkMessageHub().onStalkMessage(message);
    _messageStreamController.sink.add(message);
  }
}
