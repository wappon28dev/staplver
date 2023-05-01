import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repository/config.dart';
import '../../vm/contents.dart';
import '../../vm/projects.dart';
import '../../vm/theme.dart';
import '../class/app.dart';
import '../class/config.dart';
import '../constant.dart';
import '../error/exception.dart';

class AppConfigHelper {
  Future<List<Project>> appConfig2Projects(AppConfig appConfig) async {
    debugPrint('-- appConfig2Projects --');

    final savedProjectPath = <Directory, Directory>{};

    if (appConfig.savedProjectPath.isEmpty) return Future.value(<Project>[]);

    await appConfig.savedProjectPath
        .forEachAsync((backupDir, workingDir) async {
      if (!await Directory(backupDir).exists()) {
        return Future.error(
          SystemExceptions().backupDirNotFoundOnLoad(backupDir, workingDir),
        );
      }
      if (!await Directory(workingDir).exists()) {
        return Future.error(
          SystemExceptions().workingDirNotFoundOnLoad(backupDir, workingDir),
        );
      }

      savedProjectPath.addAll({Directory(backupDir): Directory(workingDir)});
    });
    final savedProject = <Project>[];

    await savedProjectPath.forEachAsync((backupDir, workingDir) async {
      final pjConfig =
          await PjConfigRepository().getPjConfigFromBackupDir(backupDir);

      if (pjConfig == null) throw SystemExceptions().pjConfigIsNull();

      final project = await PjConfigHelper()
          .pjConfig2Project(pjConfig, backupDir, workingDir);
      savedProject.add(project);
    });
    debugPrint('-- end --');
    return Future.value(savedProject);
  }

  AppConfig getCurrentAppConfig(WidgetRef ref) {
    final projectsState = ref.read(projectsProvider);
    final contentsState = ref.read(contentsProvider);
    final themeState = ref.read(themeProvider);

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

  Future<void> updateAppConfig(WidgetRef ref) async {
    final appConfig = getCurrentAppConfig(ref);
    await AppConfigRepository().saveAppConfig(appConfig);
  }
}

class PjConfigHelper {
  PjConfig project2PjConfig(Project project) => PjConfig(
        name: project.name,
        backupMin: project.backupMin,
      );

  Future<Project> pjConfig2Project(
    PjConfig pjConfig,
    Directory backupDir,
    Directory workingDir,
  ) async {
    if (pjConfig.name.isEmpty) {
      return Future.error(
        SystemExceptions().pjNameIsInvalid(),
      );
    }
    if (pjConfig.backupMin != -1 && pjConfig.backupMin < 0) {
      return Future.error(
        SystemExceptions().backupMinIsInvalid(),
      );
    }

    return Future.value(
      Project(
        name: pjConfig.name,
        backupDir: backupDir,
        workingDir: workingDir,
        backupMin: pjConfig.backupMin,
      ),
    );
  }
}
