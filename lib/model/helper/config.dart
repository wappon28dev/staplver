import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:staplver/vm/log.dart';

import '../../repository/config.dart';
import '../../vm/contents.dart';
import '../../vm/projects.dart';
import '../../vm/theme.dart';
import '../class/app.dart';
import '../class/config.dart';
import '../constant.dart';
import '../error/exception.dart';

class AppConfigHelper {
  const AppConfigHelper._();

  static Future<List<Project>> appConfig2Projects(AppConfig appConfig) async {
    log.ds('appConfig2Projects');

    final savedProjectPath = <Directory, Directory>{};

    if (appConfig.savedProjectPath.isEmpty) return [];

    await appConfig.savedProjectPath
        .forEachAsync((backupDirStr, workingDirStr) async {
      final backupDir = Directory(backupDirStr);
      final workingDir = Directory(workingDirStr);

      if (!await backupDir.exists()) {
        throw AppConfigExceptions().dirNotFound(
          isBackupDir: true,
          missingDir: backupDir,
        );
      }
      if (!await workingDir.exists()) {
        throw AppConfigExceptions().dirNotFound(
          isBackupDir: false,
          missingDir: workingDir,
        );
      }

      savedProjectPath.addAll({backupDir: workingDir});
    });
    final savedProject = <Project>[];

    await savedProjectPath.forEachAsync((backupDir, workingDir) async {
      final pjConfig =
          await PjConfigRepository(backupDir).getPjConfigFromBackupDir();

      if (pjConfig == null) throw PjConfigExceptions().configNotFound();

      final project = await PjConfigHelper.pjConfig2Project(
        pjConfig,
        backupDir,
        workingDir,
      );
      savedProject.add(project);
    });
    log
      ..t('savedProject: $savedProject')
      ..df('appConfig2Projects');
    return savedProject;
  }

  static AppConfig getCurrentAppConfig(WidgetRef ref) {
    final projectsState = ref.read(projectsPod);
    final contentsState = ref.read(contentsPod);
    final themeState = ref.read(appThemePod);

    final savedProjectPath = <String, String>{};

    for (final element in projectsState.savedProjects) {
      savedProjectPath.addAll(
        {element.backupDir.path: element.workingDir.path},
      );
    }

    return AppConfig(
      savedProjectPath: savedProjectPath,
      defaultBackupDir: contentsState.defaultBackupDir?.path,
      themeMode: themeState.themeMode.index,
      useDynamicColor: themeState.useDynamicColor,
    );
  }

  static Future<void> updateAppConfig(WidgetRef ref) async {
    final appConfig = getCurrentAppConfig(ref);
    await AppConfigRepository().saveAppConfig(appConfig);
  }
}

class PjConfigHelper {
  const PjConfigHelper._();

  static PjConfig project2PjConfig(Project project) => PjConfig(
        name: project.name,
        backupMin: project.backupMin,
      );

  static Future<Project> pjConfig2Project(
    PjConfig pjConfig,
    Directory backupDir,
    Directory workingDir,
  ) async {
    if (pjConfig.name.isEmpty) {
      throw PjConfigExceptions().pjNameIsInvalid();
    }
    if (pjConfig.backupMin != -1 && pjConfig.backupMin < 0) {
      throw PjConfigExceptions().backupMinIsInvalid();
    }

    return Project(
      name: pjConfig.name,
      backupDir: backupDir,
      workingDir: workingDir,
      backupMin: pjConfig.backupMin,
    );
  }
}
