import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/error/handler.dart';
import '../../model/helper/config.dart';
import '../../repository/config.dart';
import '../../vm/contents.dart';
import '../../vm/log.dart';
import '../../vm/page.dart';
import '../../vm/projects.dart';
import '../../vm/theme.dart';
import '../components/wizard.dart';

class RouteController {
  RouteController(this.ref);
  WidgetRef ref;

  static void runPush({
    required BuildContext context,
    required Widget page,
    bool isReplace = false,
    bool isFullscreen = false,
  }) {
    if (!isReplace) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => page,
          fullscreenDialog: isFullscreen,
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
    log.i('$START initializing app ...');
    final pageNotifier = ref.read(pagePod.notifier);
    final projectsNotifier = ref.read(projectsPod.notifier);
    final contentsNotifier = ref.read(contentsPod.notifier);
    final themeNotifier = ref.read(appThemePod.notifier);
    final snackBar = SnackBarController(context, ref);

    try {
      final appConfig = await AppConfigRepository().getAppConfig();
      final savedProjects = await AppConfigHelper.appConfig2Projects(appConfig);

      Directory? defaultBackupDir;

      if (appConfig.defaultBackupDir?.isNotEmpty ?? false) {
        defaultBackupDir = Directory(appConfig.defaultBackupDir ?? '');
      }

      log.ds('applying app config');

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

      log
        ..df('applying app config')
        ..i('$FINISH initializing app');
    } on Exception catch (err, trace) {
      SystemErrorHandler(context, ref).noticeErr(err, trace);
    }
  }

  void home2fabInit() {
    ref.read(pagePod.notifier).updateWizardIndex(0);
    ref.read(CompWizard.isValidContentsPod.notifier).state = false;
  }
}
