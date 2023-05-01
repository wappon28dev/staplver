import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/state.dart';

part 'theme.g.dart';

@riverpod
class AppTheme extends _$AppTheme {
  @override
  AppThemeState build() {
    return const AppThemeState();
  }

  void updateThemeMode(ThemeMode newThemeMode) {
    debugPrint('newThemeMode => $newThemeMode');
    state = state.copyWith(themeMode: newThemeMode);
  }

  // ignore: avoid_positional_boolean_parameters
  void updateUseDynamicColor(bool newUseDynamicColor) {
    debugPrint('newUseDynamicColor => $newUseDynamicColor');
    state = state.copyWith(useDynamicColor: newUseDynamicColor);
  }

  ThemeData getLightTheme(ColorScheme? lightColorScheme, BuildContext context) {
    var scheme = ColorScheme.fromSeed(
      seedColor: Colors.green,
    );

    if (state.useDynamicColor && lightColorScheme != null) {
      scheme = lightColorScheme;
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'LINE Seed JP',
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: const TextStyle(fontFamily: 'LINE Seed JP'),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }

  ThemeData getDarkTheme(ColorScheme? darkColorScheme, BuildContext context) {
    var scheme = ColorScheme.fromSeed(
      seedColor: Colors.green,
      brightness: Brightness.dark,
    );

    if (state.useDynamicColor && darkColorScheme != null) {
      scheme = darkColorScheme;
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,
      fontFamily: 'LINE Seed JP',
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: const TextStyle(fontFamily: 'LINE Seed JP'),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }
}
