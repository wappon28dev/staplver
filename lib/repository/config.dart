import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:staplver/model/class/app.dart';
import 'package:staplver/vm/log.dart';

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
      AppConfigExceptions().invalid(),
    );
  } on FileSystemException catch (err) {
    if (err.osError?.errorCode == 2) {
      return Failure(
        AppConfigExceptions().configNotFound(),
      );
    }
    return Failure(
      AppConfigExceptions().cannotLoad(err.osError?.message),
    );
    // ignore: avoid_catching_errors
  } on TypeError catch (err) {
    return Failure(
      AppConfigExceptions().cannotLoad(err.toString()),
    );
  }
  return Success(parsedJson);
}

class AppConfigRepository {
  Future<File> get appConfigFile async {
    final appConfigDir = await getApplicationSupportDirectory();
    return Future.value(File('${appConfigDir.path}/config.json'));
  }

  Future<AppConfig> getAppConfig() async {
    log.ds('loading appConfig');

    final appConfig = switch (
        await parseJson<AppConfig>(await appConfigFile, AppConfig.fromJson)) {
      Success(value: final value) => value,
      Failure(exception: final exception) => throw exception,
    };

    try {
      ThemeMode.values[appConfig.themeMode].name;
    } on Exception catch (_, __) {
      throw PjConfigExceptions().themeModeIsInvalid();
    }

    log
      ..v('appConfig: $appConfig')
      ..df('loading appConfig');
    return appConfig;
  }

  Future<void> saveAppConfig(AppConfig appConfig) async {
    log.ds('saving appConfig');

    final appConfigStr = json.encode(appConfig.toJson());
    await (await appConfigFile).writeAsString(appConfigStr);

    log
      ..v('appConfig: $appConfig')
      ..df('saving appConfig');
  }

  Future<void> removeSavedProject(
    Directory backupDir,
  ) async {
    final appConfig = await AppConfigRepository().getAppConfig();
    final savedProjectsPath = {...appConfig.savedProjectPath}
      ..remove(backupDir.path);

    final appConfigModded =
        appConfig.copyWith(savedProjectPath: savedProjectsPath);

    final appConfigStr = json.encode(appConfigModded.toJson());
    await (await appConfigFile).writeAsString(appConfigStr);
  }

  Future<void> writeEmptyAppConfig() async {
    log.ds('creating empty appConfig');

    const emptyAppConfig = AppConfig(
      savedProjectPath: {},
      defaultBackupDir: '',
      themeMode: 0,
      useDynamicColor: true,
    );
    final appConfigStr = json.encode(emptyAppConfig.toJson());
    await (await appConfigFile).writeAsString(appConfigStr);

    log.df('creating empty appConfig');
  }
}

class PjConfigRepository {
  PjConfigRepository(this.backupDir);
  Directory backupDir;

  Directory get pjDir => Directory('${backupDir.path}/_staplver');
  File get pjConfigFile => File('${pjDir.path}/config.json');
  Future<bool> get getIsPjDir async => pjDir.exists();

  Future<PjConfig?> getPjConfigFromBackupDir() async {
    log.ds('Loading pjConfig...');

    if (!await getIsPjDir) {
      throw PjConfigExceptions()
          .dirNotFound(isBackupDir: true, missingDir: backupDir);
    }

    final pjConfig = switch (await parseJson<PjConfig>(
      pjConfigFile,
      PjConfig.fromJson,
    )) {
      Success(value: final value) => value,
      Failure(exception: final exception) => throw exception,
    };

    log
      ..v('config: $pjConfig')
      ..df('loading pjConfig');
    return pjConfig;
  }

  Future<void> createNewPjConfig(PjConfig pjConfig) async {
    log.ds('creating new pjConfig');

    if (await pjDir.exists()) {
      throw ProjectExceptions().pjAlreadyExists();
    } else {
      await pjDir.create();
    }
    final pjConfigStr = json.encode(pjConfig.toJson());
    await pjConfigFile.writeAsString(pjConfigStr);

    log
      ..v('config: $pjConfig')
      ..df('creating new pjConfig');
  }

  Future<void> updatePjConfig(PjConfig pjConfig) async {
    log.ds('updating pjConfig...');

    if (!await backupDir.exists()) {
      throw PjConfigExceptions()
          .dirNotFound(isBackupDir: true, missingDir: backupDir);
    }

    if (!await getIsPjDir) {
      throw ProjectExceptions().pjNotFound();
    }

    final pjConfigStr = json.encode(pjConfig.toJson());
    await pjConfigFile.writeAsString(pjConfigStr);

    log
      ..v('config: $pjConfig')
      ..df('updating pjConfig');
  }
}
