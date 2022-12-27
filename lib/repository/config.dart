import 'dart:convert';
import 'dart:io';

import 'package:aibas/model/constant.dart';
import 'package:aibas/model/data/class.dart';
import 'package:aibas/model/data/config.dart';
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
      return Future.error('workingDir not found');
    }
    if (!await Directory(pjConfig.backupDirStr).exists()) {
      return Future.error('backupDir not found');
    }
    if (pjConfig.name.isEmpty) {
      return Future.error('name is empty');
    }
    if (pjConfig.backupMin != -1 && pjConfig.backupMin < 0) {
      return Future.error('backupMin is invalid');
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

    if (projectsState.savedProjects == null) {
      throw Exception('savedProject is null !');
    }

    final savedProjectPath = <String, String>{};

    for (final element in projectsState.savedProjects!) {
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
        return Future.error('backupDir not found');
      }

      if (!await Directory(workingDir).exists()) {
        return Future.error('workingDir not found');
      }

      savedProjectPath.addAll({Directory(backupDir): Directory(workingDir)});
    });
    final savedProject = <Project>[];

    await savedProjectPath.forEachAsync((backupDir, workingDir) async {
      final pjConfig = await loadPjConfig(backupDir);

      if (pjConfig == null) return Future.error('pjConfig is null!');

      final project = await pjConfig2Project(pjConfig);
      savedProject.add(project);
    });
    debugPrint('-- end --');
    return Future.value(savedProject);
  }

  Future<void> loadAppConfig(WidgetRef ref) async {
    debugPrint('-- load appConfig --');
    final projectsNotifier = ref.read(projectsProvider.notifier);
    final contentsNotifier = ref.read(contentsProvider.notifier);
    final themeNotifier = ref.read(themeProvider.notifier);

    AppConfig? appConfig;

    try {
      final appConfigJson =
          json.decode(await (await appConfigPath).readAsString())
              as Map<String, dynamic>;
      appConfig = AppConfig.fromJson(appConfigJson);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint(e.toString());
    }

    if (appConfig == null) return;
    final savedProjects = await appConfig2Projects(appConfig);

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

    debugPrint('config: $appConfig');
    debugPrint('-- loaded appConfig --');
  }

  Future<void> saveAppConfig(WidgetRef ref) async {
    debugPrint('-- save appConfig --');

    final appConfig = getCurrentAppConfig(ref);
    final appConfigStr = json.encode(appConfig.toJson());
    await (await appConfigPath).writeAsString(appConfigStr);

    debugPrint(appConfigStr);
    debugPrint('-- saved appConfig --');
  }

  Future<PjConfig?> loadPjConfig(Directory backupDir) async {
    debugPrint('-- load pjConfig --');

    if (!await Directory('${backupDir.path}/aibas').exists()) {
      return Future.error('pj directory no exists');
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
      return Future.error('pj already exists');
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
