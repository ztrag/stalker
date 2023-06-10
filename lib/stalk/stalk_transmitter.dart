import 'package:geolocator/geolocator.dart';
import 'package:stalker/db/db.dart';
import 'package:stalker/domain/user.dart';
import 'package:stalker/location/position_fetcher.dart';
import 'package:stalker/stalk/stalk_protocol.dart';
import 'package:stalker/user/active_user.dart';

class StalkTransmitter {
  void sendTransmission(User target) {
    listener() {
      final position = LocationFetcher.position.value;
      if (position != null) {
        StalkProtocol().sendPosition(target, position);
        _storeLocation(position);
      }
    }

    LocationFetcher.trackLocation();
    LocationFetcher.position.addListener(listener);
    Future.delayed(const Duration(seconds: 10), () {
      LocationFetcher.position.removeListener(listener);
      LocationFetcher.stopTracking();
    });
  }

  void _storeLocation(Position position) async {
    final db = await Db.db;
    db.writeTxn(() async {
      final saved = ActiveUser().value!;
      saved.lastLocationLatitude = position.latitude;
      saved.lastLocationLongitude = position.longitude;
      saved.lastLocationTimestamp = position.timestamp;
      saved.lastLocationAccuracy = position.accuracy;
      return db.users.put(saved);
    });
  }
}
