import 'package:flutter/widgets.dart';
import 'package:stalker/countdown_time/time_elapsed_text.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data.dart';

class UserTimeSinceLastLocation extends StatefulWidget {
  final User user;
  final TextStyle? style;
  final bool includeSuffix;
  final double? textScaleFactor;

  const UserTimeSinceLastLocation({
    Key? key,
    required this.user,
    this.style,
    this.includeSuffix = false,
    this.textScaleFactor,
  }) : super(key: key);

  @override
  State<UserTimeSinceLastLocation> createState() =>
      _UserTimeSinceLastLocationState();
}

class _UserTimeSinceLastLocationState extends State<UserTimeSinceLastLocation> {
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
    return AnimatedBuilder(
      animation: liveUser,
      builder: (_, __) => TimeElapsedText(
        event: liveUser.value!.lastLocationTimestamp,
        style: widget.style,
        includeSuffix: widget.includeSuffix,
        textScaleFactor: widget.textScaleFactor,
      ),
    );
  }
}
