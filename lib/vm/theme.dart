import 'package:aibas/model/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeState>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState());

  void updateThemeMode(ThemeMode newThemeMode) {
    if (kDebugMode) print('newThemeMode => $newThemeMode');
    state = state.copyWith(themeMode: newThemeMode);
  }

  ThemeData getLightTheme(ColorScheme? lightColorScheme) {
    var scheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
    );

    if (state.useDynamicColor && lightColorScheme != null) {
      scheme = lightColorScheme;
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
    );
  }

  ThemeData getDarkTheme(ColorScheme? darkColorScheme) {
    var scheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    );

    if (state.useDynamicColor && darkColorScheme != null) {
      scheme = darkColorScheme;
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
    );
  }
}
