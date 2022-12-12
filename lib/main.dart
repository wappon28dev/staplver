import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/theme.dart';
import 'package:drag_and_drop_windows/drag_and_drop_windows.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'view/routes/top_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    dropEventStream
        .listen(ref.read(contentsProvider.notifier).handleDragAndDrop);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
        return MaterialApp(
          title: 'AIBAS',
          theme: ThemeNotifier().getLightTheme(lightColorScheme),
          darkTheme: ThemeNotifier().getDarkTheme(darkColorScheme),
          themeMode: themeState.themeMode,
          debugShowCheckedModeBanner: false,
          home: const TopPage(),
        );
      },
    );
  }
}
