import 'package:flutter/foundation.dart';

void slog(String s) {
  if (kDebugMode) {
    print('[stalker] $s');
  }
}
