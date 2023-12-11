import 'package:flutter/material.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/user/active_user.dart';
import 'package:stalker/user/token_text.dart';
import 'package:stalker/user/user_distance_from_stalker.dart';
import 'package:stalker/user/user_time_since_last_location.dart';

class UserCardCenterColumn extends StatelessWidget {
  final User user;

  const UserCardCenterColumn({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasName = user.name?.isNotEmpty ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        hasName
            ? Text(
                user.name!,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            : Container(),
        TokenText(
          user: user,
          maxLines: hasName ? 1 : 2,
        ),
        Row(
          children: [
            UserTimeSinceLastLocation(
              user: user,
              includeSuffix: true,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            if (user.id != ActiveUser().value?.id) ...[
              const SizedBox(
                height: 10,
                child: VerticalDivider(),
              ),
              UserDistanceFromStalker(
                user: user,
                withAwaySuffix: true,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
