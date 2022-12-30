import 'dart:io';

import 'package:aibas/model/constant.dart';
import 'package:aibas/model/data/class.dart';
import 'package:aibas/model/data/config.dart';
import 'package:aibas/model/error/exception.dart';
import 'package:aibas/repository/config.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/projects.dart';
import 'package:aibas/vm/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppConfigHelper {
  Future<List<Project>> appConfig2Projects(AppConfig appConfig) async {
    debugPrint('-- appConfig2Projects --');

    final savedProjectPath = <Directory, Directory>{};

    if (appConfig.savedProjectPath.isEmpty) return Future.value(<Project>[]);

    await appConfig.savedProjectPath
        .forEachAsync((backupDir, workingDir) async {
      if (!await Directory(backupDir).exists()) {
        return Future.error(
          AIBASException.backupDirNotFoundOnLoad(backupDir, workingDir),
        );
      }
      if (!await Directory(workingDir).exists()) {
        return Future.error(
          AIBASException.workingDirNotFoundOnLoad(backupDir, workingDir),
        );
      }

      savedProjectPath.addAll({Directory(backupDir): Directory(workingDir)});
    });
    final savedProject = <Project>[];

    await savedProjectPath.forEachAsync((backupDir, _) async {
      final pjConfig =
          await PjConfigRepository().getPjConfigFromBackupDir(backupDir);

      if (pjConfig == null) throw AIBASException.pjConfigIsNull;

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
        AIBASException.workingDirNotFound,
      );
    }
    if (!await Directory(pjConfig.backupDirStr).exists()) {
      return Future.error(
        AIBASException.backupDirNotFound,
      );
    }
    if (pjConfig.name.isEmpty) {
      return Future.error(
        AIBASException.pjNameIsInvalid,
      );
    }
    if (pjConfig.backupMin != -1 && pjConfig.backupMin < 0) {
      return Future.error(
        AIBASException.backupMinIsInvalid,
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
