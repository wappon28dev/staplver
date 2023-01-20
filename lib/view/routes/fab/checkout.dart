import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/class/app.dart';
import '../../../model/constant.dart';
import '../../../vm/contents.dart';
import '../../../vm/page.dart';
import '../../components/checkout/pj_summary.dart';
import '../../components/checkout/set_backup_dir.dart';
import '../../components/checkout/set_working_dir.dart';
import '../../components/wizard.dart';
import '../../util/route.dart';

class PageCheckout extends HookConsumerWidget {
  const PageCheckout({super.key});

  static final workingDirProvider = StateProvider<Directory?>((ref) => null);
  static final backupDirProvider = StateProvider<Directory?>((ref) => null);
  static final newPjDataProvider = StateProvider<Project?>((ref) => null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // notifier
    final contentsNotifier = ref.read(contentsProvider.notifier);

    // local
    final backupDirNotifier = ref.read(backupDirProvider.notifier);
    final workingDirNotifier = ref.read(workingDirProvider.notifier);
    final newPjDataNotifier = ref.read(PageCheckout.newPjDataProvider.notifier);

    // init
    void init() {
      debugPrint('-- init (home -> createPj) --');
      RouteController(ref).home2fabInit();
      workingDirNotifier.state = null;
      newPjDataNotifier.state = null;
      contentsNotifier.updateDragAndDropCallback(
        (newDir) => backupDirNotifier.state = newDir,
      );
      debugPrint('-- end --');
    }

    useEffect(() => onMounted(init), []);

    // view
    final components = <WizardComponents>[
      WizardComponents(
        title: 'バックアップフォルダーの選択',
        runInit: () => contentsNotifier.updateDragAndDropCallback(
          (newDir) => backupDirNotifier.state = newDir,
        ),
        icon: Icons.folder_copy,
        screen: const CompSetBackupDir(),
      ),
      WizardComponents(
        title: '作業フォルダーの選択',
        runInit: () => contentsNotifier.updateDragAndDropCallback(
          (newDir) => workingDirNotifier.state = newDir,
        ),
        icon: Icons.drive_file_move,
        screen: const CompSetWorkingDir(),
      ),
      WizardComponents(
        title: 'プロジェクト設定の確認',
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

    void runDispose(BuildContext context, WidgetRef ref) {
      Navigator.pop(context);
      ref.read(contentsProvider.notifier).updateDragAndDropCallback(null);
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
