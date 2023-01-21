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
          AIBASExceptions().backupDirNotFoundOnLoad(backupDir, workingDir),
        );
      }
      if (!await Directory(workingDir).exists()) {
        return Future.error(
          AIBASExceptions().workingDirNotFoundOnLoad(backupDir, workingDir),
        );
      }

      savedProjectPath.addAll({Directory(backupDir): Directory(workingDir)});
    });
    final savedProject = <Project>[];

    await savedProjectPath.forEachAsync((backupDir, _) async {
      final pjConfig =
          await RepositoryPjConfig().getPjConfigFromBackupDir(backupDir);

      if (pjConfig == null) throw AIBASExceptions().pjConfigIsNull();

      final project = await PjConfigHelper().pjConfig2Project(pjConfig);
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
        workingDirStr: project.workingDir.path,
        backupDirStr: project.backupDir.path,
        backupMin: project.backupMin,
      );

  Future<Project> pjConfig2Project(PjConfig pjConfig) async {
    if (!await Directory(pjConfig.workingDirStr).exists()) {
      return Future.error(
        AIBASExceptions().workingDirNotFound(),
      );
    }
    if (!await Directory(pjConfig.backupDirStr).exists()) {
      return Future.error(
        AIBASExceptions().backupDirNotFound(),
      );
    }
    if (pjConfig.name.isEmpty) {
      return Future.error(
        AIBASExceptions().pjNameIsInvalid(),
      );
    }
    if (pjConfig.backupMin != -1 && pjConfig.backupMin < 0) {
      return Future.error(
        AIBASExceptions().backupMinIsInvalid(),
      );
    }

    return Future.value(
      Project(
        name: pjConfig.name,
        workingDir: Directory(pjConfig.workingDirStr),
        backupDir: Directory(pjConfig.backupDirStr),
        backupMin: pjConfig.backupMin,
      ),
    );
  }
}
