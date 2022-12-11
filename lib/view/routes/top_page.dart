import 'package:aibas/view/components/bottom_navigation_bar.dart';
import 'package:aibas/vm/directory.dart';
import 'package:aibas/vm/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopPage extends ConsumerWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final contentsState = ref.watch(contentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter MVVM')),
      bottomNavigationBar: bottomNavigationBar,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(contentsState.targetDirectory?.path ?? 'null'),
            Text(themeState.themeMode.name),
          ],
        ),
      ),
    );
  }
}
