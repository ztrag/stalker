import 'package:stalker/domain/user.dart';
import 'package:stalker/location/position_fetcher.dart';
import 'package:stalker/stalk/stalk_protocol.dart';

class StalkTransmitter {
  void sendTransmission(User target) {
    listener() {
      final position = LocationFetcher.position.value;
      if (position != null) {
        StalkProtocol().sendPosition(target, position);
      }
    }

    LocationFetcher.trackLocation();
    LocationFetcher.position.addListener(listener);
    Future.delayed(const Duration(seconds: 10), () {
      LocationFetcher.position.removeListener(listener);
      LocationFetcher.stopTracking();
    });
  }
}
