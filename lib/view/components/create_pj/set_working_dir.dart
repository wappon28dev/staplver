import 'dart:io';

import 'package:aibas/model/state.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompSetWorkingDir extends ConsumerWidget {
  const CompSetWorkingDir({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsState = ref.watch(contentsProvider);
    final contentsNotifier = ref.read(contentsProvider.notifier);

    Future<void> handleClick() async {
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) return;
      contentsNotifier
        ..updateDirectoryKinds(DirectoryKinds.working)
        ..updateWorkingDirectory(Directory(selectedDirectory));

      final list = contentsState.workingDirectory?.listSync(recursive: true);
      print(list?.asMap());
    }

    return Column(
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
                    'バージョン管理をするフォルダーを\nドラッグ&ドロップ',
                    style:
                        myTextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const Icon(Icons.create_new_folder, size: 100),
                  Text(
                    'または, クリックしてフォルダーを選択',
                    style:
                        myTextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
