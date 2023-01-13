import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/data/class.dart';
import '../../model/error/handler.dart';
import '../../model/helper/config.dart';
import '../../repository/config.dart';
import '../../vm/contents.dart';
import '../../vm/page.dart';
import '../../vm/projects.dart';
import '../../vm/theme.dart';
import '../components/wizard.dart';
import '../routes/fab/checkout.dart';
import '../routes/fab/create_pj.dart';
import '../routes/fab/import_pj.dart';

class RouteController {
  RouteController(this.ref);
  WidgetRef ref;

  static void runPush({
    required BuildContext context,
    required Widget page,
    bool isReplace = false,
  }) {
    if (!isReplace) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => page,
        ),
      );
    } else {
      Navigator.pushAndRemoveUntil<void>(
        context,
        MaterialPageRoute<void>(builder: (context) => page),
        (_) => false,
      );
    }
  }

  Future<void> appInit(BuildContext context) async {
    final pageNotifier = ref.read(pageProvider.notifier);
    final projectsNotifier = ref.read(projectsProvider.notifier);
    final contentsNotifier = ref.read(contentsProvider.notifier);
    final themeNotifier = ref.read(themeProvider.notifier);
    final snackBar = SnackBarController(context, ref);

    try {
      final appConfig = await AppConfigRepository().getAppConfig();
      final savedProjects =
          await AppConfigHelper().appConfig2Projects(appConfig);

      Directory? defaultBackupDir;

      if (appConfig.defaultBackupDir?.isNotEmpty ?? false) {
        defaultBackupDir = Directory(appConfig.defaultBackupDir ?? '');
      }

      // state notifier
      projectsNotifier.updateSavedProject(savedProjects);
      contentsNotifier.updateDefaultBackupDir(defaultBackupDir);
      themeNotifier
        ..updateThemeMode(ThemeMode.values[appConfig.themeMode])
        ..updateUseDynamicColor(appConfig.useDynamicColor);

      if (appConfig.savedProjectPath.isEmpty) {
        snackBar.pushSnackBarSuccess(content: '設定ファイルが正しく読み込まれました');
      } else {
        snackBar.pushSnackBarSuccess(
          content: '${appConfig.savedProjectPath.length} 件のプロジェクトが正しく読み込まれました',
        );
      }
      await pageNotifier.completeProgress();
    } on AIBASException catch (err, trace) {
      AIBASErrHandler(context, ref).noticeErr(err, trace);
      // ignore: avoid_catches_without_on_clauses
    } catch (err, trace) {
      AIBASErrHandler(context, ref).noticeUnhandledErr(err, trace);
    }
  }

  void _home2fabInit() {
    ref.read(pageProvider.notifier).updateWizardIndex(0);
    ref.read(CompWizard.isValidContentsProvider.notifier).state = false;
  }

  void home2createPj() {
    final contentsState = ref.watch(contentsProvider);
    final contentsNotifier = ref.read(contentsProvider.notifier);

    // local
    final pjNameNotifier = ref.read(PageCreatePj.pjNameProvider.notifier);
    final workingDirNotifier =
        ref.read(PageCreatePj.workingDirProvider.notifier);
    final backupDirNotifier = ref.read(PageCreatePj.backupDirProvider.notifier);
    final ignoreFilesNotifier =
        ref.read(PageCreatePj.ignoreFilesProvider.notifier);

    debugPrint('-- init (home -> createPj) --');
    _home2fabInit();
    pjNameNotifier.state = '';
    workingDirNotifier.state = null;
    backupDirNotifier.state = contentsState.defaultBackupDir;
    ignoreFilesNotifier.state = [];
    contentsNotifier.updateDragAndDropCallback(
      (newDir) => workingDirNotifier.state = newDir,
    );
    debugPrint('-- end --');
  }

  void home2importPj() {
    final contentsNotifier = ref.read(contentsProvider.notifier);

    // local
    final workingDirNotifier =
        ref.read(PageImportPj.workingDirProvider.notifier);
    final importedPjNotifier =
        ref.read(PageImportPj.importedPjProvider.notifier);

    debugPrint('-- init (home -> importPj) --');
    _home2fabInit();
    workingDirNotifier.state = null;
    importedPjNotifier.state = null;
    contentsNotifier.updateDragAndDropCallback(
      (newDir) => workingDirNotifier.state = newDir,
    );
    debugPrint('-- end --');
  }

  void home2checkout() {
    final contentsNotifier = ref.read(contentsProvider.notifier);

    // local
    final backupDirNotifier = ref.read(PageCheckout.backupDirProvider.notifier);
    final workingDirNotifier =
        ref.read(PageCheckout.workingDirProvider.notifier);
    final newPjDataNotifier = ref.read(PageCheckout.newPjDataProvider.notifier);

    debugPrint('-- init (home -> createPj) --');
    _home2fabInit();
    workingDirNotifier.state = null;
    newPjDataNotifier.state = null;
    contentsNotifier.updateDragAndDropCallback(
      (newDir) => backupDirNotifier.state = newDir,
    );
    debugPrint('-- end --');
  }
}
