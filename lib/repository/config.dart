import 'dart:convert';
import 'dart:io';

import 'package:aibas/model/constant.dart';
import 'package:aibas/model/data/class.dart';
import 'package:aibas/model/data/config.dart';
import 'package:aibas/model/error/exception.dart';
import 'package:aibas/model/helper/snackbar.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/projects.dart';
import 'package:aibas/vm/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class ConfigController {
  Future<File> get appConfigPath async {
    final appConfigDir = await getApplicationSupportDirectory();
    return Future.value(File('${appConfigDir.path}/config.json'));
  }

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
      final pjConfig = await loadPjConfig(backupDir);

      if (pjConfig == null) throw AIBASException.pjConfigIsNull;

      final project = await pjConfig2Project(pjConfig);
      savedProject.add(project);
    });
    debugPrint('-- end --');
    return Future.value(savedProject);
  }

  Future<AppConfig> loadAppConfig() async {
    debugPrint('-- load appConfig --');

    AppConfig? appConfig;

    try {
      final appConfigJson =
          json.decode(await (await appConfigPath).readAsString())
              as Map<String, dynamic>;
      appConfig = AppConfig.fromJson(appConfigJson);

      // ignore: avoid_catching_errors
    } on TypeError {
      return Future.error(
        AIBASException.appConfigIsInvalid,
      );
    } on FormatException {
      return Future.error(
        AIBASException.appConfigIsInvalid,
      );
    } on FileSystemException catch (err) {
      if (err.osError?.errorCode == 2) {
        return Future.error(AIBASException.appConfigNotFound);
      }
      return Future.error(
        AIBASException.appConfigCannotLoaded(err.osError?.message),
      );
    }

    try {
      ThemeMode.values[appConfig.themeMode].name;
      // ignore: avoid_catches_without_on_clauses
    } catch (_, __) {
      return Future.error(
        AIBASException.pjConfigThemeModeIsInvalid,
      );
    }

    debugPrint('config: $appConfig');
    debugPrint('-- loaded appConfig --');
    return Future.value(appConfig);
  }

  Future<void> saveAppConfig(WidgetRef ref) async {
    debugPrint('-- save appConfig --');

    final appConfig = getCurrentAppConfig(ref);
    final appConfigStr = json.encode(appConfig.toJson());
    await (await appConfigPath).writeAsString(appConfigStr);

    debugPrint(appConfigStr);
    debugPrint('-- saved appConfig --');
  }

  Future<void> removeSavedProject(
    String backupDirStr,
  ) async {
    final appConfig = await loadAppConfig();
    final savedProjectsPath = {...appConfig.savedProjectPath}
      ..remove(backupDirStr);

    final appConfigModded =
        appConfig.copyWith(savedProjectPath: savedProjectsPath);

    final appConfigStr = json.encode(appConfigModded.toJson());
    await (await appConfigPath).writeAsString(appConfigStr);
  }

  Future<bool> getIsPjDir(Directory backupDir) async =>
      Directory('${backupDir.path}/aibas').exists();

  Future<PjConfig?> loadPjConfig(Directory backupDir) async {
    debugPrint('-- load pjConfig --');

    if (!await getIsPjDir(backupDir)) {
      return Future.error(AIBASException.pjNotFound);
    }

    PjConfig? pjConfig;

    try {
      final pjConfigStr =
          await File('${backupDir.path}/aibas/pj_config.json').readAsString();

      final pjConfigJson = json.decode(pjConfigStr) as Map<String, dynamic>;
      pjConfig = PjConfig.fromJson(pjConfigJson);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint('target: ${backupDir.path}/aibas/pj_config');
    debugPrint('config: $pjConfig');
    debugPrint('-- loaded pjConfig -- ');
    return Future.value(pjConfig);
  }

  Future<void> createPjConfig(Project project) async {
    debugPrint('-- create pjConfig --');

    if (await Directory('${project.backupDir.path}/aibas').exists()) {
      return Future.error(AIBASException.pjAlreadyExists);
    } else {
      await Directory('${project.backupDir.path}/aibas').create();
    }

    final pjConfigPath = File('${project.backupDir.path}/aibas/pj_config.json');
    final pjConfigStr = json.encode(project2PjConfig(project).toJson());
    await pjConfigPath.writeAsString(pjConfigStr);

    debugPrint('$pjConfigStr\n-- created pjConfig --');
  }

  Future<void> createEmptyAppConfig() async {
    debugPrint('-- create emptyConfig --');
    const emptyAppConfig = AppConfig(
      savedProjectPath: {},
      defaultBackupDir: '',
      themeMode: 0,
      useDynamicColor: false,
    );
    final appConfigStr = json.encode(emptyAppConfig.toJson());
    await (await appConfigPath).writeAsString(appConfigStr);
    debugPrint(appConfigStr);
    debugPrint('-- created emptyConfig --');
  }
}
