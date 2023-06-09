import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/class/app.dart';
import '../../../model/constant.dart';
import '../../../model/error/exception.dart';
import '../../../model/error/handler.dart';
import '../../../model/helper/config.dart';
import '../../../repository/config.dart';
import '../../../vm/contents.dart';
import '../../../vm/page.dart';
import '../../../vm/projects.dart';
import '../../components/import_pj/pj_summary.dart';
import '../../components/import_pj/set_working_dir.dart';
import '../../components/wizard.dart';
import '../../util/route.dart';

class PageImportPj extends HookConsumerWidget {
  const PageImportPj({super.key});
  static final workingDirProvider = StateProvider<Directory?>((ref) => null);
  static final importedPjProvider = StateProvider<Project?>((ref) => null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // notifier
    final contentsNotifier = ref.read(contentsPod.notifier);

    // local
    final workingDirNotifier = ref.read(workingDirProvider.notifier);
    final importedPjNotifier = ref.read(importedPjProvider.notifier);

    // init
    void init() {
      debugPrint('-- init (home -> importPj) --');
      RouteController(ref).home2fabInit();
      workingDirNotifier.state = null;
      importedPjNotifier.state = null;
      contentsNotifier.updateDragAndDropCallback(
        (newDir) => workingDirNotifier.state = newDir,
      );
      debugPrint('-- end --');
    }

    useEffect(() => onMounted(init), []);

    // view
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
      final pageState = ref.watch(pagePod);
      final pageNotifier = ref.read(pagePod.notifier);
      final index = pageState.wizardIndex;

      pageNotifier.updateWizardIndex(index + 1);
      components[index + 1].runInit();
    }

    void runPreviousPage(WidgetRef ref) {
      final pageState = ref.watch(pagePod);
      final pageNotifier = ref.read(pagePod.notifier);
      final index = pageState.wizardIndex;

      pageNotifier.updateWizardIndex(index - 1);
      components[index - 1].runInit();
    }

    Future<void> runImportPj(BuildContext context, WidgetRef ref) async {
      final importedPjState = ref.read(importedPjProvider);
      final projectsNotifier = ref.read(projectsPod.notifier);

      if (importedPjState == null) {
        throw ProjectExceptions().importedPjIsNull();
      }
      projectsNotifier.addSavedProject(importedPjState);
      final appConfig = AppConfigHelper.getCurrentAppConfig(ref);
      await AppConfigRepository()
          .saveAppConfig(appConfig)
          .catchError(SystemErrorHandler(context, ref).noticeErr);
    }

    void runDispose(BuildContext context, WidgetRef ref) {
      Navigator.pop(context);
      ref.read(contentsPod.notifier).updateDragAndDropCallback(null);
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
