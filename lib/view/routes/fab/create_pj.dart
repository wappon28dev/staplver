import 'dart:io';

import 'package:aibas/model/constant.dart';
import 'package:aibas/model/data/class.dart';
import 'package:aibas/repository/config.dart';
import 'package:aibas/view/components/create_pj/set_ignore_files.dart';
import 'package:aibas/view/components/create_pj/set_pj_config.dart';
import 'package:aibas/view/components/create_pj/set_pj_details.dart';
import 'package:aibas/view/components/create_pj/set_working_dir.dart';
import 'package:aibas/view/components/wizard.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/page.dart';
import 'package:aibas/vm/projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageCreatePj extends ConsumerWidget {
  const PageCreatePj({super.key});

  static final pjNameProvider = StateProvider<String>((ref) => '');
  static final workingDirProvider = StateProvider<Directory?>((ref) => null);
  static final backupDirProvider = StateProvider<Directory?>((ref) => null);
  static final ignoreFilesProvider =
      StateProvider<List<FileSystemEntity>>((ref) => []);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsNotifier = ref.read(contentsProvider.notifier);
    final workingDirNotifier = ref.read(workingDirProvider.notifier);
    final backupDirNotifier = ref.read(backupDirProvider.notifier);
    final pjNameNotifier = ref.read(pjNameProvider.notifier);

    final components = [
      WizardComponents(
        title: '作業フォルダーの選択',
        runInit: () => contentsNotifier.updateDragAndDropCallback(
          (newDir) => workingDirNotifier.state = newDir,
        ),
        icon: Icons.drive_file_move,
        screen: const CompSetWorkingDir(),
      ),
      WizardComponents(
        title: 'バージョンの管理外にする ファイル/フォルダー を選択',
        runInit: () {
          pjNameNotifier.state = workingDirNotifier.state?.name ?? '';
          contentsNotifier.updateDragAndDropCallback(null);
        },
        icon: Icons.folder_off,
        screen: CompSetIgnoreFiles(),
      ),
      WizardComponents(
        title: 'プロジェクトの設定',
        runInit: () => contentsNotifier.updateDragAndDropCallback(
          (newDir) => backupDirNotifier.state = newDir,
        ),
        icon: Icons.settings,
        screen: const CompSetPjConfig(),
      ),
      WizardComponents(
        title: 'プロジェクトの詳細',
        runInit: () => contentsNotifier.updateDragAndDropCallback(null),
        icon: Icons.settings_suggest,
        screen: const CompSetPjDetails(),
      ),
    ];

    void runNextPage(WidgetRef ref) {
      final pageState = ref.watch(pageProvider);
      final pageNotifier = ref.read(pageProvider.notifier);
      final index = pageState.wizardIndex;

      pageNotifier.updateWizardIndex(index + 1);
      components[index + 1].runInit();
    }

    void runPreviousPage(WidgetRef ref) {
      final pageState = ref.watch(pageProvider);
      final pageNotifier = ref.read(pageProvider.notifier);
      final index = pageState.wizardIndex;

      pageNotifier.updateWizardIndex(index - 1);
      components[index - 1].runInit();
    }

    Future<void> runCreateProject(WidgetRef ref) async {
      final projectsNotifier = ref.watch(projectsProvider.notifier);

      final pjNameState = ref.watch(pjNameProvider);
      final workingDirState = ref.watch(workingDirProvider);
      final backupDirState = ref.watch(backupDirProvider);

      if (workingDirState == null || backupDirState == null) {
        throw Exception('newProject contains null!');
      }

      final newProject = Project(
        name: pjNameState,
        workingDir: workingDirState,
        backupDir: backupDirState,
        backupMin: 20,
      );

      projectsNotifier.addSavedProject(newProject);
      await projectsNotifier.initProject();
      await ConfigController().saveAppConfig(ref);
    }

    void runDispose(BuildContext context, WidgetRef ref) {
      Navigator.pop(context);
      ref.read(contentsProvider.notifier).updateDragAndDropCallback(null);
    }

    return CompWizard(
      wizardText: '新規プロジェクトの作成',
      finishText: '作成',
      runNextPage: () => runNextPage(ref),
      runPreviousPage: () => runPreviousPage(ref),
      components: components,
      onFinished: () async {
        await runCreateProject(ref);
        // ignore: use_build_context_synchronously
        runDispose(context, ref);
      },
      onCanceled: () => runDispose(context, ref),
    ).parentWrap(context: context, ref: ref);
  }
}
