import 'dart:io';

import 'package:aibas/model/state.dart';
import 'package:aibas/view/routes/create_pj.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/svn.dart';
import 'package:aibas/vm/theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:drag_and_drop_windows/drag_and_drop_windows.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompSetWorkingDir extends ConsumerWidget {
  const CompSetWorkingDir({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsNotifier = ref.read(contentsProvider.notifier);
    final pjNameNotifier = ref.read(pjNameProvider.notifier);
    final workingDirState = ref.watch(workingDirProvider);
    final workingDirNotifier = ref.read(workingDirProvider.notifier);

    final layout = CompCreatePjHelper();

    dropEventStream.listen(
      (paths) async => contentsNotifier.getSingleDirectory(paths).then(
        (dir) {
          workingDirNotifier.state = dir;
          pjNameNotifier.state = dir.name;
        },
      ),
    );

    bool isValidContents() {
      return workingDirState != null;
    }

    Future<void> handleClick() async {
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) return;
      final dir = Directory(selectedDirectory);
      workingDirNotifier.state = dir;
      pjNameNotifier.state = dir.name;
    }

    return layout.wrap(
      context,
      ref,
      isValidContents(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: handleClick,
            child: DottedBorder(
              color: Theme.of(context).colorScheme.tertiary,
              dashPattern: const [15, 6],
              strokeWidth: 3,
              child: Container(
                height: 400,
                width: 400,
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'バージョン管理をするフォルダーを\nドラッグ & ドロップ',
                      style: myTextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const Icon(Icons.create_new_folder, size: 100),
                    Text(
                      'または, クリックしてフォルダーを選択',
                      style: myTextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: TextButton.icon(
              label: const Text('リセット'),
              icon: const Icon(Icons.restart_alt),
              onPressed: isValidContents()
                  ? () => workingDirNotifier.state = null
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          Text(workingDirState?.path ?? '')
        ],
      ),
    );
  }
}
