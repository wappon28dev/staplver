import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:staplver/model/class/app.dart';

import '../model/class/config.dart';
import '../model/error/exception.dart';
import '../model/result.dart';

Future<Result<T, SystemException>> parseJson<T>(
  File file,
  T Function(Map<String, dynamic>) parseMethod,
) async {
  T parsedJson;
  try {
    final decodedJson =
        json.decode(await file.readAsString()) as Map<String, dynamic>;
    parsedJson = parseMethod(decodedJson);
  } on FormatException {
    return Failure(
      SystemExceptions().appConfigIsInvalid(),
    );
  } on FileSystemException catch (err) {
    if (err.osError?.errorCode == 2) {
      throw SystemExceptions().appConfigNotFound();
    }
    return Failure(
      SystemExceptions().appConfigCannotLoaded(err.osError?.message),
    );
    // ignore: avoid_catching_errors
  } on TypeError catch (err) {
    return Failure(
      SystemExceptions().appConfigCannotLoaded(err.toString()),
    );
  }
  return Success(parsedJson);
}

class AppConfigRepository {
  Future<File> get appConfigPath async {
    final appConfigDir = await getApplicationSupportDirectory();
    return Future.value(File('${appConfigDir.path}/config.json'));
  }

  Future<AppConfig> getAppConfig() async {
    debugPrint('-- load appConfig --');

    final appConfig = switch (
        await parseJson<AppConfig>(await appConfigPath, AppConfig.fromJson)) {
      Success(value: final value) => value,
      Failure(exception: final exception) => throw exception,
    };

    try {
      ThemeMode.values[appConfig.themeMode].name;
    } on Exception catch (_, __) {
      throw SystemExceptions().pjConfigThemeModeIsInvalid();
    }

    debugPrint('config: $appConfig');
    debugPrint('-- loaded appConfig --');
    return appConfig;
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
      useDynamicColor: true,
    );
    final appConfigStr = json.encode(emptyAppConfig.toJson());
    await (await appConfigPath).writeAsString(appConfigStr);
    debugPrint(appConfigStr);
    debugPrint('-- created emptyConfig --');
  }
}

class PjConfigRepository {
  Future<bool> getIsPjDir(Directory backupDir) async =>
      Directory('${backupDir.path}/staplver').exists();

  Future<PjConfig?> getPjConfigFromBackupDir(Directory backupDir) async {
    debugPrint('-- load pjConfig --');

    if (!await getIsPjDir(backupDir)) {
      throw SystemExceptions().pjNotFound();
    }

    final pjConfig = switch (await parseJson<PjConfig>(
      File('${backupDir.path}/staplver/pj_config.json'),
      PjConfig.fromJson,
    )) {
      Success(value: final value) => value,
      Failure(exception: final exception) => throw exception,
    };

    debugPrint('target: ${backupDir.path}/staplver/pj_config');
    debugPrint('config: $pjConfig');
    debugPrint('-- loaded pjConfig -- ');
    return Future.value(pjConfig);
  }

  Future<void> createNewPjConfig(PjConfig pjConfig, Directory backupDir) async {
    debugPrint('-- create pjConfig --');

    final backupDirStr = backupDir.path;

    if (await Directory('$backupDirStr/staplver').exists()) {
      throw SystemExceptions().pjAlreadyExists();
    } else {
      await Directory('$backupDirStr/staplver').create();
    }
    final pjConfigPath = File('$backupDirStr/staplver/pj_config.json');
    final pjConfigStr = json.encode(pjConfig.toJson());
    await pjConfigPath.writeAsString(pjConfigStr);

    debugPrint('$pjConfigStr\n-- created pjConfig --');
  }

  Future<void> updatePjConfig(PjConfig pjConfig, Directory backupDir) async {
    debugPrint('-- update pjConfig --');

    if (!await backupDir.exists()) {
      throw SystemExceptions().backupDirNotFound();
    }

    if (!await getIsPjDir(backupDir)) {
      throw SystemExceptions().pjNotFound();
    }

    final pjConfigPath = File('$backupDir/staplver/pj_config.json');
    final pjConfigStr = json.encode(pjConfig.toJson());
    await pjConfigPath.writeAsString(pjConfigStr);

    debugPrint('$pjConfigStr\n-- update pjConfig --');
  }
}
