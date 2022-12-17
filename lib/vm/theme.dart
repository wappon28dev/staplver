import 'package:aibas/model/state.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeState>((ref) => ThemeNotifier());

const myTextStyle = GoogleFonts.bizUDPGothic;

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState());

  void updateThemeMode(ThemeMode newThemeMode) {
    debugPrint('newThemeMode => $newThemeMode');
    state = state.copyWith(themeMode: newThemeMode);
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
      fontFamily: myTextStyle().fontFamily,
      textTheme: TextTheme(
        bodyText1: myTextStyle(fontWeight: FontWeight.w500),
        bodyText2: myTextStyle(fontWeight: FontWeight.w500),
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
      fontFamily: myTextStyle().fontFamily,
      textTheme: TextTheme(
        bodyText1: myTextStyle(fontWeight: FontWeight.w500),
        bodyText2: myTextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
