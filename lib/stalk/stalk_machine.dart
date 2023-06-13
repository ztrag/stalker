import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/stalk/stalk_protocol.dart';
import 'package:stalker/stalk/stalk_transmitter.dart';
import 'package:stalker/user/active_user.dart';

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
  final ValueNotifier<bool> isInContinuousMode = ValueNotifier(false);
  DateTime? _currentSessionStartTime;
  int _continuousSessionCount = 0;

  StalkMachine(this.target);

  void dispose() {
    _messagesWatch?.cancel();
    isAvailable.dispose();
    hasSent.dispose();
    hasReceivedAck.dispose();
    hasReceivedLocation.dispose();
    isInContinuousMode.dispose();
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
      case StalkAction.stalkRequestInterrupt:
        isInContinuousMode.value = false;
        StalkTransmitter(target).interruptTransmission();
        break;
    }
  }

  void stalk() {
    _startSession();
    _stalk();
  }

  void _startSession() {
    _currentSessionStartTime = DateTime.now();
    isAvailable.value = false;
    hasSent.value = false;
    hasReceivedAck.value = false;
    hasReceivedLocation.value = false;
    isInContinuousMode.value = false;
    Future.delayed(const Duration(seconds: 10), () {
      isAvailable.value = !isInContinuousMode.value;
      if (isAvailable.value) {
        _interruptSession();
      }
    });
  }

  void _stalk() async {
    _messagesWatch ??= StalkProtocol.messages.listen(_handleMessage);
    _addToHistory(StalkMachineAction.sendingRequest);
    final stalkRequestFuture =
        StalkProtocol().sendMessage(target, StalkAction.stalkRequest);
    StalkTransmitter(target).sendTransmission(ActiveUser().value!);
    final result = await stalkRequestFuture;

    _addToHistory(result
        ? StalkMachineAction.sentRequest
        : StalkMachineAction.failedRequest);
    if (!result) {
      throw 'FAIL';
    }

    hasSent.value = true;
  }

  void toggleContinuousMode() async {
    const period = Duration(seconds: 10);
    final elapsed = DateTime.now().difference(_currentSessionStartTime!);

    isInContinuousMode.value = !isInContinuousMode.value;
    if (!isInContinuousMode.value) {
      isAvailable.value = true;
      _interruptSession();
      return;
    }

    final session = ++_continuousSessionCount;
    var firstSleep = period < elapsed ? const Duration() : (period - elapsed);
    await Future.delayed(firstSleep);
    while (isInContinuousMode.value && session == _continuousSessionCount) {
      hasSent.value = false;
      _stalk();
      await Future.delayed(period);
    }
  }

  void ack() {
    _addToHistory(StalkMachineAction.ackRequest);
  }

  void _addToHistory(StalkMachineAction action) {
    history.value = {...history.value, DateTime.now(): action};
  }

  void _interruptSession() {
    StalkTransmitter(target).interruptTransmission();
    StalkProtocol().sendMessage(target, StalkAction.stalkRequestInterrupt);
  }
}
