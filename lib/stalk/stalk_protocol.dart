import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/stalk_target.dart';

enum StalkAction {
  stalkRequest(1),
  stalkRequestAck(2);

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

  StalkMessage({required this.action, required this.sender});
}

class StalkProtocol {
  static final StreamController<StalkMessage> _messageStreamController =
      StreamController<StalkMessage>.broadcast();

  static final Stream<StalkMessage> messages = _messageStreamController.stream;

  StalkProtocol();

  void handleFcm(RemoteMessage message) async {
    print('fcm ${message.senderId} -> ${message.data}');
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
    _handleStalkMessage(
        StalkMessage(action: stalkAction, sender: targets.first));
  }

  void _handleStalkMessage(StalkMessage message) {
    _messageStreamController.sink.add(message);
    switch (message.action) {
      case StalkAction.stalkRequest:
        sendStalkMessage(message.sender.token!, StalkAction.stalkRequestAck);
        return;
      case StalkAction.stalkRequestAck:
        return;
    }
  }

  Future<bool> sendStalkMessage(String token, StalkAction message) {
    return _sendFcm(token, {'c': message.code});
  }

  Future<bool> _sendFcm(String token, Map<String, dynamic> data) async {
    final sender = await FirebaseMessaging.instance.getToken();
    final result = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAO_390dw:APA91bHmann0MjxGVuKX6NBXQgPQbXUX66i67Au7uOaCAkVBGwRGk0SRo6XyIuzcyPBLO3rXNx7qWJaH08B5E6fSaPB-JERvpevgK6cZPYis6Qbeb-1Uc8eAH4__PIjBnsPwlJXC6wC6',
      },
      body: jsonEncode(
        <String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{...data, 'f': sender!},
          "to": token,
        },
      ),
    );

    print('${result.statusCode}:${result.body}');
    if (result.statusCode == 200) {
      return true;
    }
    return false;
  }
}
