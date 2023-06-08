import 'package:flutter/cupertino.dart';
import 'package:stalker/stalk/stalk_protocol.dart';

class StalkMessageHub {
  static final StalkMessageHub _instance = StalkMessageHub._();
  
  final Map<int, ValueNotifier<int>> _recentMessageCounts = {};
  
  StalkMessageHub._();

  factory StalkMessageHub() => _instance;
  
  ValueNotifier<int> getRecentMessagesNotifier(int senderId) {
    return _recentMessageCounts[senderId] ??= ValueNotifier(0);
  }

  void onStalkMessage(StalkMessage message) {
    var notifier = getRecentMessagesNotifier(message.sender.id);
    ++notifier.value;
    Future.delayed(const Duration(seconds: 10),(){
      --notifier.value;
    });
  }
}
