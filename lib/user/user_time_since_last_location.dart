import 'package:flutter/widgets.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data_builder.dart';
import 'package:stalker/ticker/ticker_text.dart';

class UserTimeSinceLastLocation extends StatelessWidget {
  final User user;
  final TextStyle? style;
  final bool includeSuffix;
  final TextScaler? textScaler;

  const UserTimeSinceLastLocation({
    Key? key,
    required this.user,
    this.style,
    this.includeSuffix = false,
    this.textScaler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiveDataBuilder<User>(
      initial: user,
      prepare: (db, user) => user.inCollection(db.users),
      builder: (user) => TickerText(
        event: user?.lastLocationTimestamp,
        style: style,
        includeSuffix: includeSuffix,
        textScaler: textScaler,
      ),
    );
  }
}
