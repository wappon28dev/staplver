import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/class/app.dart';
import '../../../model/constant.dart';
import '../../../model/helper/config.dart';
import '../../../vm/contents.dart';
import '../../../vm/page.dart';
import '../../../vm/projects.dart';
import '../../components/create_pj/set_ignore_files.dart';
import '../../components/create_pj/set_pj_config.dart';
import '../../components/create_pj/set_pj_details.dart';
import '../../components/create_pj/set_working_dir.dart';
import '../../components/wizard.dart';
import '../../util/route.dart';

class PageCreatePj extends HookConsumerWidget {
  const PageCreatePj({super.key});

  static final pjNameProvider = StateProvider<String>((ref) => '');
  static final workingDirProvider = StateProvider<Directory?>((ref) => null);
  static final backupDirProvider = StateProvider<Directory?>((ref) => null);
  static final ignoreFilesProvider =
      StateProvider<List<FileSystemEntity>>((ref) => []);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // state
    final contentsState = ref.watch(contentsPod);

    // notifier
    final contentsNotifier = ref.read(contentsPod.notifier);
    final workingDirNotifier = ref.read(workingDirProvider.notifier);
    final backupDirNotifier = ref.read(backupDirProvider.notifier);

    // local
    final pjNameNotifier = ref.read(pjNameProvider.notifier);
    final ignoreFilesNotifier = ref.read(ignoreFilesProvider.notifier);

    // init
    void init() {
      debugPrint('-- init (home -> createPj) --');
      RouteController(ref).home2fabInit();
      pjNameNotifier.state = '';
      workingDirNotifier.state = null;
      backupDirNotifier.state = contentsState.defaultBackupDir;
      ignoreFilesNotifier.state = [];
      contentsNotifier.updateDragAndDropCallback(
        (newDir) => workingDirNotifier.state = newDir,
      );
      debugPrint('-- end --');
    }

    useEffect(() => onMounted(init), []);

    // view
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
        screen: const CompSetIgnoreFiles(),
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

    Future<void> runCreateProject(WidgetRef ref) async {
      final projectsNotifier = ref.watch(projectsPod.notifier);

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

      await AppConfigHelper().updateAppConfig(ref);
    }

    void runDispose(BuildContext context, WidgetRef ref) {
      Navigator.pop(context);
      ref.read(contentsPod.notifier).updateDragAndDropCallback(null);
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
