import 'package:aibas/view/root.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/theme.dart';

import 'package:drag_and_drop_windows/drag_and_drop_windows.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('ja_JP');
  runApp(const ProviderScope(child: AIBAS()));
}

class AIBAS extends ConsumerWidget {
  const AIBAS({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    dropEventStream
        .listen(ref.read(contentsProvider.notifier).handleDragAndDrop);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
        return MaterialApp(
          title: 'AIBAS',
          theme: ThemeNotifier().getLightTheme(lightColorScheme, context),
          darkTheme: ThemeNotifier().getDarkTheme(darkColorScheme, context),
          themeMode: themeState.themeMode,
          debugShowCheckedModeBanner: false,
          home: const AppRoot(),
        );
      },
    );
  }
}
