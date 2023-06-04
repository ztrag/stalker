import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stalker/domain/stalk_target.dart';

class StalkMachine {
  final StalkTarget target;

  const StalkMachine(this.target);

  void stalk() {
    print(target.token!);
    // FirebaseMessaging.instance.sendMessage(
    //   to: target.token!,
    //   data: <String, String>{
    //     'action': 'stalk-request',
    //   },
    // );
  }
}
