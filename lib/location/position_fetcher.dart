import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationFetcher {
  static final ValueNotifier<Position?> position = ValueNotifier(null);
  static StreamSubscription<Position?>? _inputStreamSubscription;

  static Future<bool> checkPermissions() async {
    final locationPermission = await Geolocator.requestPermission();
    return locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse;
  }

  static void trackLocation() async {
    if (!(await checkPermissions())) {
      return;
    }

    _inputStreamSubscription ??=
        Geolocator.getPositionStream(locationSettings: const LocationSettings())
            .listen((event) {
      position.value = event;
    });
    Geolocator.getLastKnownPosition().then((value) {
      if (value != null) {
        position.value = value;
      }
    });
  }

  static Future<Position> getCurrentPosition() async {
    if (!(await checkPermissions())) {
      throw 'No permission';
    }

    return Geolocator.getCurrentPosition();
  }

  static void stopTracking() {
    _inputStreamSubscription?.cancel();
    _inputStreamSubscription = null;
  }
}
