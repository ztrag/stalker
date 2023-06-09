import 'package:flutter/material.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/edit_active_user_page.dart';
import 'package:stalker/user/user_card_center_column.dart';
import 'package:stalker/user/user_enabled_switch.dart';
import 'package:stalker/user/user_icon_widget.dart';

class StalkerCard extends StatelessWidget {
  const StalkerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ValueListenableBuilder<User?>(
        valueListenable: ActiveUser(),
        builder: (_, user, child) => Material(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: _getCardColor(context),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) => const EditActiveUserPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: kUserIconSize,
                        height: kUserIconSize,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UserIconWidget(user: user!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: UserCardCenterColumn(user: user)),
                      const SizedBox(width: 8),
                      UserEnabledSwitch(user: user),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(BuildContext context) {
    final theme = Theme.of(context);
    return ActiveUser().value!.isEnabled
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surface;
  }
}
