import 'package:flutter/material.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data.dart';
import 'package:stalker/user/active_user.dart';

class UserEnabledSwitch extends StatefulWidget {
  final User user;
  final ValueChanged<bool>? onValueChanged;

  const UserEnabledSwitch({Key? key, required this.user, this.onValueChanged})
      : super(key: key);

  @override
  State<UserEnabledSwitch> createState() => _UserEnabledSwitchState();

  static void toggleInDb(User user, [bool? value]) async {
    final db = await Db.db;
    db.writeTxn(() async {
      final saved = await db.users.get(user.id);
      saved!.isEnabled = value ?? !saved.isEnabled;
      return db.users.put(saved);
    });
  }
}

class _UserEnabledSwitchState extends State<UserEnabledSwitch> {
  late final LiveData<User> liveUser = LiveData(widget.user);

  @override
  void initState() {
    super.initState();

    Db.db.then((db) => liveUser.inCollection(db.users));
  }

  @override
  void dispose() {
    liveUser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (liveUser.value == null) {
      return Container();
    }
    final isActiveUser = ActiveUser().value!.id == liveUser.value!.id;
    return AnimatedBuilder(
      animation: Listenable.merge([liveUser, if (!isActiveUser) ActiveUser()]),
      builder: (_, __) {
        final isHidden = !isActiveUser && !ActiveUser().value!.isEnabled;
        return AnimatedOpacity(
          opacity: isHidden ? 0.1 : 1,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: isHidden,
            child: Switch(
              value: liveUser.value!.isEnabled,
              onChanged: (v) {
                UserEnabledSwitch.toggleInDb(liveUser.value!, v);
                if (widget.onValueChanged != null) {
                  widget.onValueChanged!(v);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
