import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:stalker/domain/stalk_target.dart';

enum StalkMachineAction {
  sendingRequest,
  failedRequest,
  sentRequest,
  receivedResponse,
}

class StalkMachine {
  final StalkTarget target;
  final ValueNotifier<Map<DateTime, StalkMachineAction>> history =
      ValueNotifier({});

  StalkMachine(this.target);

  void stalk() {
    _addToHistory(StalkMachineAction.sendingRequest);
    sendPushMessage(
      target.token!,
      {'action': 'stalk-request'},
    );
  }

  void _addToHistory(StalkMachineAction action) {
    print('stalk-machine action ->$action');
    history.value = {...history.value, DateTime.now(): action};
  }

  void sendPushMessage(String token, Map<String, dynamic> data) async {
    try {
      final x = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAO_390dw:APA91bHmann0MjxGVuKX6NBXQgPQbXUX66i67Au7uOaCAkVBGwRGk0SRo6XyIuzcyPBLO3rXNx7qWJaH08B5E6fSaPB-JERvpevgK6cZPYis6Qbeb-1Uc8eAH4__PIjBnsPwlJXC6wC6',
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': data,
            "to": token,
          },
        ),
      );

      _addToHistory(x.statusCode == 200
          ? StalkMachineAction.sentRequest
          : StalkMachineAction.failedRequest);
    } catch (e) {
      _addToHistory(StalkMachineAction.failedRequest);
    }
  }
}
