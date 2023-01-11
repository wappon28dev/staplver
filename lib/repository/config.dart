import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../model/data/config.dart';
import '../model/error/exception.dart';

class AppConfigRepository {
  Future<File> get appConfigPath async {
    final appConfigDir = await getApplicationSupportDirectory();
    return Future.value(File('${appConfigDir.path}/config.json'));
  }

  Future<AppConfig> getAppConfig() async {
    debugPrint('-- load appConfig --');

    AppConfig? appConfig;

    try {
      final appConfigJson =
          json.decode(await (await appConfigPath).readAsString())
              as Map<String, dynamic>;
      appConfig = AppConfig.fromJson(appConfigJson);

      // ignore: avoid_catching_errors
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

  Future<void> saveAppConfig(AppConfig appConfig) async {
    debugPrint('-- save appConfig --');

    final appConfigStr = json.encode(appConfig.toJson());
    await (await appConfigPath).writeAsString(appConfigStr);

    debugPrint(appConfigStr);
    debugPrint('-- saved appConfig --');
  }

  Future<void> removeSavedProject(
    String backupDirStr,
  ) async {
    final appConfig = await AppConfigRepository().getAppConfig();
    final savedProjectsPath = {...appConfig.savedProjectPath}
      ..remove(backupDirStr);

    final appConfigModded =
        appConfig.copyWith(savedProjectPath: savedProjectsPath);

    final appConfigStr = json.encode(appConfigModded.toJson());
    await (await appConfigPath).writeAsString(appConfigStr);
  }

  Future<void> writeEmptyAppConfig() async {
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

class PjConfigRepository {
  Future<bool> getIsPjDir(Directory backupDir) async =>
      Directory('${backupDir.path}/aibas').exists();

  Future<PjConfig?> getPjConfigFromBackupDir(Directory backupDir) async {
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

  Future<void> createNewPjConfig(PjConfig pjConfig) async {
    debugPrint('-- create pjConfig --');

    if (await Directory('${pjConfig.backupDirStr}/aibas').exists()) {
      return Future.error(AIBASException.pjAlreadyExists);
    } else {
      await Directory('${pjConfig.backupDirStr}/aibas').create();
    }

    final pjConfigPath = File('${pjConfig.backupDirStr}/aibas/pj_config.json');
    final pjConfigStr = json.encode(pjConfig.toJson());
    await pjConfigPath.writeAsString(pjConfigStr);

    debugPrint('$pjConfigStr\n-- created pjConfig --');
  }

  Future<void> updatePjConfig(PjConfig pjConfig) async {
    debugPrint('-- update pjConfig --');

    if (!await Directory('${pjConfig.backupDirStr}/aibas').exists()) {
      return Future.error(AIBASException.pjNotFound);
    } else {
      await Directory('${pjConfig.backupDirStr}/aibas').create();
    }

    final pjConfigPath = File('${pjConfig.backupDirStr}/aibas/pj_config.json');
    final pjConfigStr = json.encode(pjConfig.toJson());
    await pjConfigPath.writeAsString(pjConfigStr);

    debugPrint('$pjConfigStr\n-- update pjConfig --');
  }
}
