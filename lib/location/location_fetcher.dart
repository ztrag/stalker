import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationFetcher {
  static final ValueNotifier<Position?> currentPosition = ValueNotifier(null);
  static StreamSubscription<Position?>? _inputStreamSubscription;

  static void trackLocation() async {
    var locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse) {
      _inputStreamSubscription ??= Geolocator.getPositionStream(
              locationSettings: const LocationSettings())
          .listen((event) {
        currentPosition.value = event;
      });
      Geolocator.getLastKnownPosition().then((value) {
        currentPosition.value = value;
      });
    }
  }

  static void stopTracking() {
    _inputStreamSubscription?.cancel();
    _inputStreamSubscription = null;
  }
}
