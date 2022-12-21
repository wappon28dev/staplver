import 'dart:io';

import 'package:aibas/view/routes/fab/create_pj.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/svn.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompSetPjConfig extends ConsumerWidget {
  const CompSetPjConfig({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsState = ref.watch(contentsProvider);

    // local ref
    final pjNameState = ref.watch(pjNameProvider);
    final pjNameNotifier = ref.read(pjNameProvider.notifier);
    final workingDirState = ref.watch(workingDirProvider);
    final backupDirState = ref.watch(backupDirProvider);
    final backupDirNotifier = ref.read(backupDirProvider.notifier);

    final textController = TextEditingController(text: backupDirState?.path);

    bool isValidContents() {
      // null check
      if (workingDirState == null || backupDirState == null) return false;

      return workingDirState.existsSync() && backupDirState.existsSync();
    }

    String getWorkingDirStr() {
      if (workingDirState != null) {
        return '${workingDirState.path} (指定済み)';
      } else {
        return throw Exception('contentsState.workingDirectory is null');
      }
    }

    Future<void> handleClick() async {
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) return;
      backupDirNotifier.state = Directory(selectedDirectory);
    }

    String? getBackupDirStr() {
      if (contentsState.defaultBackupDir != null) {
        return '${contentsState.defaultBackupDir?.path} (既定)';
      }

      return null;
    }

    String? validator(String? newVal) {
      if (newVal == null || newVal.isEmpty) {
        return 'バックアップフォルダーのパスを入力してください';
      }

      try {
        if (!Directory(newVal).existsSync()) {
          return '入力したバックアップフォルダーのパスは存在しません';
        }
        // ignore: avoid_catches_without_on_clauses
      } catch (_, __) {
        return '入力したバックアップフォルダーのパスは存在しません';
      }

      return null;
    }

    final pjNameField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: const [
              Icon(Icons.badge, size: 47),
              Text('プロジェクト名'),
            ],
          ),
        ),
        Expanded(
          flex: 12,
          child: TextFormField(
            autofocus: true,
            initialValue: workingDirState?.name ?? '',
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'プロジェクト名を入力してください';
              }
              return null;
            },
            onChanged: (newVal) => pjNameNotifier.state = newVal,
            decoration: InputDecoration(
              errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              labelText: '重複しないプロジェクト名を入力',
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: pjNameState.isNotEmpty
              ? const Icon(Icons.check)
              : Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
        ),
      ],
    );

    final workingDirField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: const [
              Icon(Icons.folder, size: 47),
              Text('作業フォルダー'),
            ],
          ),
        ),
        Expanded(
          flex: 13,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: getWorkingDirStr(),
              enabled: false,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );

    final backupDirField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: const [
              Icon(Icons.folder_copy, size: 47),
              Text('バックアップ\nフォルダー', textAlign: TextAlign.center),
            ],
          ),
        ),
        Expanded(
          flex: 12,
          child: TextFormField(
            controller: textController,
            autovalidateMode: AutovalidateMode.always,
            validator: validator,
            decoration: InputDecoration(
              hintText: getBackupDirStr() ?? '(ドラッグアンドドロップでも指定可)',
              border: const OutlineInputBorder(),
            ),
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

    return CompCreatePjHelper().wrap(
      context,
      ref,
      isValidContents(),
      Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),
                pjNameField,
                const SizedBox(height: 40),
                workingDirField,
                const SizedBox(height: 40),
                backupDirField,
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: TextButton.icon(
              label: const Text('リセット'),
              icon: const Icon(Icons.restart_alt),
              onPressed: () => textController.text =
                  contentsState.defaultBackupDir?.path ??
                      backupDirState?.path ??
                      '',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
