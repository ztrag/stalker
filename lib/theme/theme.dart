import 'package:flutter/material.dart';

ColorScheme getDarkColorScheme() {
  final seed = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorSchemeSeed: Colors.pink,
  ).colorScheme;
  return const ColorScheme.dark().copyWith(
    primary: seed.primary,
    onPrimary: seed.onPrimary,
    primaryContainer: seed.primaryContainer,
    onPrimaryContainer: seed.onPrimaryContainer,
    secondary: seed.secondary,
    onSecondary: seed.onSecondary,
    secondaryContainer: seed.secondaryContainer,
    onSecondaryContainer: seed.onSecondaryContainer,
    error: seed.error,
    onError: seed.onError,
    errorContainer: seed.errorContainer,
    onErrorContainer: seed.onErrorContainer,
    onBackground: seed.onBackground,
    onSurface: seed.onSurface,
    surfaceVariant: seed.surfaceVariant,
    onSurfaceVariant: seed.onSurfaceVariant,
  );
}
