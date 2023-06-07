import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/edit_active_user_page.dart';
import 'package:stalker/user/user_enabled_switch.dart';
import 'package:stalker/user/user_icon_widget.dart';

class StalkerCard extends StatelessWidget {
  const StalkerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: AnimatedBuilder(
        animation: ActiveUser(),
        builder: (_, child) => Material(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: _getCardColor(context),
            child: child,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            Share.share(ActiveUser().value!.token!);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (c) => const EditActiveUserPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UserIconWidget(user: ActiveUser().value!),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: ActiveUser(),
                        builder: (_, __) => Text(
                          ActiveUser().value!.name!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        ActiveUser().value!.token!,
                        style: const TextStyle(fontSize: 10),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                UserEnabledSwitch(user: ActiveUser().value!),
              ],
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
