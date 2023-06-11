import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stalker/logger/logger.dart';

class PositionFetcher {
  static final ValueNotifier<Position?> position = ValueNotifier(null);
  static StreamSubscription<Position?>? _inputStreamSubscription;

  static Future<void> checkPermissions() async {
    final result = await Geolocator.requestPermission();
    final hasPermissions = result == LocationPermission.always ||
        result == LocationPermission.whileInUse;
    if (!hasPermissions) {
      slog('[location-fetcher] Has no permissions');
      // TODO show toast or something.
    }
  }

  static void startTracking() async {
    _inputStreamSubscription ??=
        Geolocator.getPositionStream(locationSettings: const LocationSettings())
            .listen((event) {
      position.value = event;
    });
    Geolocator.getCurrentPosition().then((value) {
      position.value = value;
    });
  }

  static void stopTracking() {
    _inputStreamSubscription?.cancel();
    _inputStreamSubscription = null;
  }
}
