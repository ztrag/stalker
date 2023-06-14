import 'package:flutter/material.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/stalk/stalk_message_hub.dart';
import 'package:stalker/theme/loading_text.dart';

class UserActivityWidget extends StatelessWidget {
  final User user;

  const UserActivityWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO Needs to load from db in case of background updates
    return ValueListenableBuilder(
      valueListenable: StalkMessageHub().getRecentMessagesNotifier(user.id),
      builder: (_, numRecentMessages, ___) => numRecentMessages <= 0
          ? Container()
          : Row(
              children: [
                Flexible(
                  child: Material(
                    color: Colors.pink.withOpacity(0.7),
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Theme(
                        data: ThemeData(
                          textTheme: Theme.of(context).textTheme.apply(
                                bodyColor: Colors.white,
                                displayColor: Colors.white,
                              ),
                        ),
                        child: LoadingText(length: numRecentMessages),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
