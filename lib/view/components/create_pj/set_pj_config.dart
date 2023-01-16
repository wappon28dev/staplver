import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/constant.dart';
import '../../../vm/contents.dart';
import '../../routes/fab/create_pj.dart';
import '../wizard.dart';

class CompSetPjConfig extends HookConsumerWidget {
  const CompSetPjConfig({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // state
    final contentsState = ref.watch(contentsProvider);

    // local - state
    final pjNameState = ref.watch(PageCreatePj.pjNameProvider);
    final workingDirState = ref.watch(PageCreatePj.workingDirProvider);
    final backupDirState = ref.watch(PageCreatePj.backupDirProvider);

    // local - notifier
    final isValidContentsNotifier =
        ref.read(CompWizard.isValidContentsProvider.notifier);
    final pjNameNotifier = ref.read(PageCreatePj.pjNameProvider.notifier);
    final backupDirNotifier = ref.read(PageCreatePj.backupDirProvider.notifier);

    // local - val
    final pjNameFormController = TextEditingController(text: pjNameState);
    final backupDirFormController =
        TextEditingController(text: backupDirState?.path ?? '');

    // local - hooks
    bool isValidContents() {
      if (workingDirState == null || backupDirState == null) return false;

      return pjNameState.isNotEmpty &&
          workingDirState.existsSync() &&
          backupDirState.existsSync();
    }

    useEffect(
      () => onMounted(() => isValidContentsNotifier.state = isValidContents()),
    );

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

    String? pjNameValidator(String? newVal) {
      if (newVal == null || newVal.isEmpty) {
        return 'プロジェクト名を入力してください';
      }
      return null;
    }

    String? backupDirValidator(String? newVal) {
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

    void updateValidState() {
      final isPjNameValid = pjNameValidator(pjNameState) == null;
      final isWorkingDirValid =
          backupDirValidator(backupDirFormController.text) == null;
      isValidContentsNotifier.state = isPjNameValid && isWorkingDirValid;
    }

    // view
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
          child: Focus(
            child: TextFormField(
              autofocus: true,
              controller: pjNameFormController,
              autovalidateMode: AutovalidateMode.always,
              validator: pjNameValidator,
              decoration: InputDecoration(
                errorStyle:
                    TextStyle(color: Theme.of(context).colorScheme.error),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                labelText: '重複しないプロジェクト名を入力',
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) {
                updateValidState();
              },
            ),
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                if (pjNameValidator(pjNameFormController.text) == null) {
                  pjNameNotifier.state = pjNameFormController.text;
                } else {
                  pjNameNotifier.state = '';
                }
              }
            },
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
          flex: 12,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: getWorkingDirStr(),
              enabled: false,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: workingDirState?.existsSync() ?? false
              ? const Icon(Icons.check)
              : Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
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
          child: Focus(
            child: TextFormField(
              controller: backupDirFormController,
              autovalidateMode: AutovalidateMode.always,
              validator: backupDirValidator,
              onChanged: (_) => updateValidState(),
              decoration: InputDecoration(
                hintText: getBackupDirStr() ?? '(ドラッグアンドドロップでも指定可)',
                border: const OutlineInputBorder(),
              ),
            ),
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                if (backupDirValidator(backupDirFormController.text) == null) {
                  backupDirNotifier.state =
                      Directory(backupDirFormController.text);
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

    return Column(
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
            onPressed: () {
              pjNameFormController.text = workingDirState?.name ?? '';
              backupDirFormController.text =
                  contentsState.defaultBackupDir?.path ??
                      backupDirState?.path ??
                      '';
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
