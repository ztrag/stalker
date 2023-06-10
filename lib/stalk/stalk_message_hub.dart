import 'package:flutter/foundation.dart';
import 'package:stalker/stalk/stalk_protocol.dart';

class StalkMessageHub {
  static final StalkMessageHub _instance = StalkMessageHub._();

  final Map<int, ValueNotifier<int>> _recentMessageCounts = {};

  StalkMessageHub._();

  factory StalkMessageHub() => _instance;

  ValueListenable<int> getRecentMessagesNotifier([int senderId = 0]) {
    return _recentMessageCounts[senderId] ??= ValueNotifier(0);
  }

  void onStalkMessage(StalkMessage message) {
    final notifiers = [message.sender.id, 0]
        .map((e) => getRecentMessagesNotifier(e) as ValueNotifier<int>);
    for (final n in notifiers) {
      ++n.value;
    }

    Future.delayed(const Duration(seconds: 2), () {
      for (final n in notifiers) {
        --n.value;
      }
    });
  }
}
