import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/edit_active_user_page.dart';
import 'package:stalker/user/user_icon_widget.dart';

class StalkerCard extends StatelessWidget {
  const StalkerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).primaryColor,
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
                    child: UserIconWidget(user: ActiveUser().value!),
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
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                      Text(
                        ActiveUser().value!.token!,
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Switch(value: true, onChanged: (v) {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
