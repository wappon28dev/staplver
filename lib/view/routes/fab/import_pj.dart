import 'dart:io';

import 'package:aibas/model/data/class.dart';
import 'package:aibas/model/error/exception.dart';
import 'package:aibas/model/helper/config.dart';
import 'package:aibas/model/helper/snackbar.dart';
import 'package:aibas/repository/config.dart';
import 'package:aibas/view/components/import_pj/pj_summary.dart';
import 'package:aibas/view/components/import_pj/set_working_dir.dart';
import 'package:aibas/view/components/wizard.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/page.dart';
import 'package:aibas/vm/projects.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PageImportPj extends ConsumerWidget {
  const PageImportPj({super.key});
  static final workingDirProvider = StateProvider<Directory?>((ref) => null);
  static final importedPjProvider = StateProvider<Project?>((ref) => null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsNotifier = ref.read(contentsProvider.notifier);
    final workingDirNotifier = ref.read(workingDirProvider.notifier);

    final components = <WizardComponents>[
      WizardComponents(
        title: '作業フォルダーの選択',
        runInit: () => contentsNotifier.updateDragAndDropCallback(
          (newDir) => workingDirNotifier.state = newDir,
        ),
        icon: Icons.folder_copy,
        screen: const CompSetWorkingDir(),
      ),
      WizardComponents(
        title: 'インポートするプロジェクトの確認',
        runInit: () => contentsNotifier.updateDragAndDropCallback(null),
        icon: Icons.settings,
        screen: const CompPjSummary(),
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

    Future<void> runImportPj(BuildContext context, WidgetRef ref) async {
      final importedPjState = ref.read(importedPjProvider);
      final projectsNotifier = ref.read(projectsProvider.notifier);

      if (importedPjState == null) {
        throw AIBASException.importedPjIsNull;
      }
      projectsNotifier.addSavedProject(importedPjState);
      final appConfig = AppConfigHelper().getCurrentAppConfig(ref);
      await AppConfigRepository()
          .saveAppConfig(appConfig)
          .catchError(SnackBarController(context, ref).errHandlerBanner);
    }

    void runDispose(BuildContext context, WidgetRef ref) {
      Navigator.pop(context);
      ref.read(contentsProvider.notifier).updateDragAndDropCallback(null);
    }

    return CompWizard(
      wizardText: '作業フォルダーからプロジェクトをインポート',
      finishText: '作成',
      runNextPage: () => runNextPage(ref),
      runPreviousPage: () => runPreviousPage(ref),
      components: components,
      onFinished: () async {
        await runImportPj(context, ref);
        // ignore: use_build_context_synchronously
        runDispose(context, ref);
      },
      onCanceled: () => runDispose(context, ref),
    ).parentWrap(context: context, ref: ref);
  }
}
