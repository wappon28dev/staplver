import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../../vm/page.dart';

class WindowController with WindowListener {
  WindowController({required this.context, required this.ref});

  final BuildContext context;
  final WidgetRef ref;

  @override
  Future<void> onWindowClose() async {
    final isPreventClose = await windowManager.isPreventClose();
    final pageState = ref.watch(pagePod);

    if (isPreventClose && pageState.askWhenQuit) {
      // ignore: use_build_context_synchronously
      await showDialog<void>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(
              '本当にウィンドウを閉じて良いですか？',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              TextButton(
                child: const Text('キャンセル'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('はい'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await windowManager.destroy();
                },
              ),
            ],
          );
        },
      );
    } else {
      await windowManager.destroy();
    }
  }
}
