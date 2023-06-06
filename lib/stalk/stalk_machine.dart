import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:stalker/domain/user.dart';
import 'package:stalker/location/position_fetcher.dart';
import 'package:stalker/stalk/stalk_protocol.dart';

enum StalkMachineAction {
  sendingRequest,
  failedRequest,
  sentRequest,
  ackRequest,
}

class StalkMachine {
  final User target;
  final ValueNotifier<Map<DateTime, StalkMachineAction>> history =
      ValueNotifier({});
  StreamSubscription<StalkMessage>? _messagesWatch;

  StalkMachine(this.target);

  void dispose() {
    _messagesWatch?.cancel();
  }

  void _handleMessage(StalkMessage message) {
    if (message.sender.id != target.id) {
      return;
    }
    switch (message.action) {
      case StalkAction.stalkRequest:
        // FIXME: Other user is stalking me too.
        return;
      case StalkAction.stalkRequestAck:
        _addToHistory(StalkMachineAction.ackRequest);
        return;
      case StalkAction.locationShare:
        return;
    }
  }

  void stalk() async {
    _messagesWatch ??= StalkProtocol.messages.listen(_handleMessage);
    _addToHistory(StalkMachineAction.sendingRequest);
    final stalkRequestFuture =
        StalkProtocol().sendMessage(target, StalkAction.stalkRequest);
    StalkProtocol()
        .sendPosition(target, await LocationFetcher.getCurrentPosition());
    final result = await stalkRequestFuture;

    _addToHistory(result
        ? StalkMachineAction.sentRequest
        : StalkMachineAction.failedRequest);
    if (!result) {
      throw 'FAIL';
    }
  }

  void ack() {
    _addToHistory(StalkMachineAction.ackRequest);
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
