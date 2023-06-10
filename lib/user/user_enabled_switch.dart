import 'package:flutter/material.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data_builder.dart';
import 'package:stalker/user/active_user.dart';

class UserEnabledSwitch extends StatelessWidget {
  final User user;
  final ValueChanged<bool>? onValueChanged;

  const UserEnabledSwitch({Key? key, required this.user, this.onValueChanged})
      : super(key: key);

  static void toggleInDb(User user, [bool? value]) async {
    final db = await Db.db;
    db.writeTxn(() async {
      final saved = await db.users.get(user.id);
      saved!.isEnabled = value ?? !saved.isEnabled;
      return db.users.put(saved);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isActiveUser = ActiveUser().value!.id == user.id;
    return LiveDataBuilder<User>(
        initial: user,
        prepare: (db, user) => user.inCollection(db.users),
        builder: (user) {
          return AnimatedBuilder(
            animation: ActiveUser(),
            builder: (_, __) {
              final isHidden = !isActiveUser && !ActiveUser().value!.isEnabled;
              if (user == null) {
                return Wrap();
              }
              return AnimatedOpacity(
                opacity: isHidden ? 0.1 : 1,
                duration: const Duration(milliseconds: 300),
                child: Switch(
                  value: user.isEnabled,
                  onChanged: (v) {
                    UserEnabledSwitch.toggleInDb(user, v);
                    if (onValueChanged != null) {
                      onValueChanged!(v);
                    }
                  },
                ),
              );
            },
          );
        });
  }
}
