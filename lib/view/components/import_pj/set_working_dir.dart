import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/error/exception.dart';
import '../../../model/error/handler.dart';
import '../../../model/helper/config.dart';
import '../../../repository/config.dart';
import '../../../vm/svn.dart';
import '../../routes/fab/import_pj.dart';
import '../drag_and_drop.dart';
import '../wizard.dart';

class CompSetWorkingDir extends ConsumerWidget {
  const CompSetWorkingDir({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // global ref
    final svnNotifier = ref.read(svnProvider.notifier);

    // wizard ref
    final isValidContentsNotifier =
        ref.read(CompWizard.isValidContentsProvider.notifier);

    // local ref
    final workingDirState = ref.watch(PageImportPj.workingDirProvider);
    final workingDirNotifier =
        ref.read(PageImportPj.workingDirProvider.notifier);

    final textController = TextEditingController(text: workingDirState?.path);
    final snackBar = SnackBarController(context, ref);

    bool isValidContents() =>
        workingDirState != null && workingDirState.existsSync();

    // state callback
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => isValidContentsNotifier.state = isValidContents(),
    );

    ref.listen(PageImportPj.workingDirProvider, (_, workingDir) async {
      if (workingDir == null) return;
      try {
        final backupDir = await svnNotifier.getBackupDir(workingDir);
        final importedPjNotifier =
            ref.read(PageImportPj.importedPjProvider.notifier);

        final pjConfig =
            await PjConfigRepository().getPjConfigFromBackupDir(backupDir);
        if (pjConfig == null) throw AIBASExceptions().pjConfigIsNull();
        final importedPj = await PjConfigHelper()
            .pjConfig2Project(pjConfig, backupDir, workingDir);

        importedPjNotifier.state = importedPj;
        snackBar.pushSnackBarSuccess(
          content: 'プロジェクト “${pjConfig.name}” は正しく読み込めます',
        );
      } on Exception catch (err, trace) {
        isValidContentsNotifier.state = false;
        AIBASErrHandler(context, ref).noticeErr(err, trace);
      }
    });

    Future<void> selectDir() async {
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) return;
      final dir = Directory(selectedDirectory);
      workingDirNotifier.state = dir;
      textController.text = dir.path;
    }

    String? validator(String? newVal) {
      if (newVal == null || newVal.isEmpty) {
        return '作業フォルダーのパスを入力してください';
      }

      try {
        if (!Directory(newVal).existsSync()) {
          return '入力した作業フォルダーのパスは存在しません';
        }
      } on Exception catch (_, __) {
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
              onChanged: (_) => isValidContentsNotifier.state =
                  validator(textController.text) == null,
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
            onPressed: selectDir,
            icon: const Icon(Icons.more_horiz),
          ),
        ),
      ],
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        dragAndDropSquare(
          selectDir,
          Theme.of(context).colorScheme,
          '作業フォルダーをドラッグ & ドロップ',
          'または, クリックしてフォルダーを選択',
          Icons.create_new_folder,
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
    );
  }
}
