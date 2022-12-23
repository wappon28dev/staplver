import 'dart:io';

import 'package:aibas/model/data/class.dart';
import 'package:aibas/view/components/checkout/pj_summary.dart';
import 'package:aibas/view/components/checkout/set_backup_dir.dart';
import 'package:aibas/view/components/checkout/set_working_dir.dart';
import 'package:aibas/view/components/wizard.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageCheckout extends ConsumerWidget {
  const PageCheckout({super.key});

  static final workingDirProvider = StateProvider<Directory?>((ref) => null);
  static final backupDirProvider = StateProvider<Directory?>((ref) => null);
  static final newPjDataProvider = StateProvider<Project?>((ref) => null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsNotifier = ref.read(contentsProvider.notifier);
    final workingDirNotifier = ref.read(workingDirProvider.notifier);
    final backupDirNotifier = ref.read(backupDirProvider.notifier);

    final components = <WizardComponents>[
      WizardComponents(
        title: 'バックアップフォルダーの選択',
        runInit: () =>
            contentsNotifier.updateDragAndDropSendTo(backupDirNotifier),
        icon: Icons.folder_copy,
        screen: const CompSetBackupDir(),
      ),
      WizardComponents(
        title: '作業フォルダーの選択',
        runInit: () =>
            contentsNotifier.updateDragAndDropSendTo(workingDirNotifier),
        icon: Icons.drive_file_move,
        screen: const CompSetWorkingDir(),
      ),
      WizardComponents(
        title: 'プロジェクト設定の確認',
        runInit: () => contentsNotifier.updateDragAndDropSendTo(null),
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

    void runDispose(BuildContext context, WidgetRef ref) {
      Navigator.pop(context);
      ref.read(contentsProvider.notifier).updateDragAndDropSendTo(null);
    }

    return CompWizard(
      wizardText: 'バックアップフォルダーから作業コピーをとる',
      finishText: '作成',
      runNextPage: () => runNextPage(ref),
      runPreviousPage: () => runPreviousPage(ref),
      components: components,
      onFinished: () => runDispose(context, ref),
      onCanceled: () => runDispose(context, ref),
    ).parentWrap(context: context, ref: ref);
  }
}
