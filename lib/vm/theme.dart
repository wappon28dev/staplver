import 'package:aibas/model/state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeState>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState());

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
      fontFamily: 'M PLUS 1',
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: const TextStyle(fontFamily: 'M PLUS 1'),
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
      fontFamily: 'M PLUS 1',
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: const TextStyle(fontFamily: 'M PLUS 1'),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }
}
