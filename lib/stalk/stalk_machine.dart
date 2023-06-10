import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/stalk/stalk_protocol.dart';
import 'package:stalker/stalk/stalk_transmitter.dart';

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
  final ValueNotifier<bool> isAvailable = ValueNotifier(true);
  final ValueNotifier<bool> hasSent = ValueNotifier(false);
  final ValueNotifier<bool> hasReceivedAck = ValueNotifier(false);
  final ValueNotifier<bool> hasReceivedLocation = ValueNotifier(false);

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
        hasReceivedAck.value = true;
        _addToHistory(StalkMachineAction.ackRequest);
        return;
      case StalkAction.locationShare:
        hasReceivedLocation.value = true;
        return;
    }
  }

  void stalk() async {
    _resetAvailability();
    _messagesWatch ??= StalkProtocol.messages.listen(_handleMessage);
    _addToHistory(StalkMachineAction.sendingRequest);
    final stalkRequestFuture =
        StalkProtocol().sendMessage(target, StalkAction.stalkRequest);
    StalkTransmitter().sendTransmission(target);
    final result = await stalkRequestFuture;

    _addToHistory(result
        ? StalkMachineAction.sentRequest
        : StalkMachineAction.failedRequest);
    if (!result) {
      throw 'FAIL';
    }

    hasSent.value = true;
  }

  void ack() {
    _addToHistory(StalkMachineAction.ackRequest);
  }

  void _addToHistory(StalkMachineAction action) {
    history.value = {...history.value, DateTime.now(): action};
  }

  void _resetAvailability() {
    isAvailable.value = false;
    hasSent.value = false;
    hasReceivedAck.value = false;
    hasReceivedLocation.value = false;
    Future.delayed(const Duration(seconds: 10), () => isAvailable.value = true);
  }
}
