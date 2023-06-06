import 'package:flutter/material.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/map/map_page.dart';
import 'package:stalker/user/user_enabled_switch.dart';
import 'package:stalker/user/user_icon_widget.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => MapPage(user: user),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: PopupMenuButton<String>(
                    onSelected: (String item) {
                      if (item == 'Delete') {
                        _delete();
                      }
                    },
                    itemBuilder: (c) => ['Delete']
                        .map((e) =>
                            PopupMenuItem<String>(value: e, child: Text(e)))
                        .toList(),
                    child: UserIconWidget(user: user),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        maxLines: 1,
                      ),
                      Text(
                        'Last seen ${user.lastLocationTimestamp}',
                        textScaleFactor: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                UserEnabledSwitch(user: user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _delete() async {
    final db = await Db.db;
    db.writeTxn(() => db.users.delete(user.id));
  }
}
