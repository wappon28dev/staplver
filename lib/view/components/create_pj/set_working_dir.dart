import 'dart:io';

import 'package:aibas/view/routes/fab/create_pj.dart';
import 'package:aibas/vm/svn.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompSetWorkingDir extends ConsumerWidget {
  const CompSetWorkingDir({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pjNameNotifier = ref.read(CompCreatePjHelper.pjNameProvider.notifier);
    final workingDirState = ref.watch(CompCreatePjHelper.workingDirProvider);
    final workingDirNotifier =
        ref.read(CompCreatePjHelper.workingDirProvider.notifier);

    final layout = CompCreatePjHelper();
    final textController = TextEditingController(text: workingDirState?.path);

    bool isValidContents() {
      return workingDirState != null;
    }

    Future<void> handleClick() async {
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) return;
      final dir = Directory(selectedDirectory);
      workingDirNotifier.state = dir;
      textController.text = dir.path;
      pjNameNotifier.state = dir.name;
    }

    String? validator(String? newVal) {
      if (newVal == null || newVal.isEmpty) {
        return '作業フォルダーのパスを入力してください';
      }

      try {
        if (!Directory(newVal).existsSync()) {
          return '入力した作業フォルダーのパスは存在しません';
        }
        // ignore: avoid_catches_without_on_clauses
      } catch (_, __) {
        return '入力した作業フォルダーのパスは存在しません';
      }

      return null;
    }

    final workingDirField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: const [
              Icon(Icons.folder, size: 47),
              Text('作業フォルダー', textAlign: TextAlign.center),
            ],
          ),
        ),
        Expanded(
          flex: 12,
          child: Focus(
            child: TextFormField(
              controller: textController,
              autovalidateMode: AutovalidateMode.always,
              validator: validator,
              decoration: const InputDecoration(
                hintText: '(ドラッグアンドドロップでも指定可)',
                border: OutlineInputBorder(),
              ),
            ),
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                if (validator(textController.text) == null) {
                  workingDirNotifier.state = Directory(textController.text);
                }
              }
            },
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: handleClick,
            icon: const Icon(Icons.more_horiz),
          ),
        ),
      ],
    );

    return layout.wrap(
      context: context,
      ref: ref,
      isValidContents: isValidContents(),
      mainContents: Column(
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
                  children: const [
                    Text(
                      'バージョン管理をするフォルダーを\nドラッグ & ドロップ',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.create_new_folder, size: 100),
                    Text(
                      'または, クリックしてフォルダーを選択',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          workingDirField,
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
        ],
      ),
    );
  }
}
