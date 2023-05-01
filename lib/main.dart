import 'package:drag_and_drop_windows/drag_and_drop_windows.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:window_manager/window_manager.dart';

import 'view/root.dart';
import 'vm/contents.dart';
import 'vm/theme.dart';

void main() async {
  await initializeDateFormatting('ja_JP');
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    minimumSize: Size(750, 770),
    title: 'staplver',
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: Staplver()));
}

class Staplver extends ConsumerWidget with WindowListener {
  const Staplver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // state
    final themeState = ref.watch(themeProvider);

    // notifier
    final contentsNotifier = ref.read(contentsProvider.notifier);

    // local
    dropEventStream.listen((paths) async {
      await contentsNotifier.handleDragAndDrop(paths);
    });

    // view
    return DynamicColorBuilder(
      builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
        return MaterialApp(
          title: 'Staplver',
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
