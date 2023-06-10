import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/live/live_data_builder.dart';
import 'package:stalker/user/active_user.dart';

class UserDistanceFromStalker extends StatelessWidget {
  final User user;

  const UserDistanceFromStalker({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ActiveUser(),
      builder: (_, __) => LiveDataBuilder<User>(
        initial: user,
        prepare: (db, user) => user.inCollection(db.users),
        builder: (user) {
          if (!(user?.hasLocation ?? false) ||
              !(ActiveUser().value?.hasLocation ?? false)) {
            return Wrap();
          }
          final distance = Geolocator.distanceBetween(
            ActiveUser().value!.lastLocationLatitude!,
            ActiveUser().value!.lastLocationLongitude!,
            user!.lastLocationLatitude!,
            user.lastLocationLongitude!,
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              _prettyDistance(distance),
              style: Theme.of(context).textTheme.labelSmall,
              textScaleFactor: 0.9,
            ),
          );
        },
      ),
    );
  }

  String _prettyDistance(double distance) {
    if (distance > 10000) {
      // i.e. 10km 100km
      return '${(distance / 1000).toStringAsFixed(0)}km';
    } else if (distance > 1000) {
      // i.e. 1.1km
      return '${(distance / 1000).toStringAsFixed(1)}km';
    }
    return '${(distance).toStringAsFixed(0)}m';
  }
}
