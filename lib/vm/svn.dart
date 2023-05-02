// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:staplver/model/constant.dart';
import 'package:staplver/vm/projects.dart';

import '../model/class/app.dart';
import '../model/class/svn.dart';
import '../model/error/exception.dart';
import '../model/state.dart';
import '../repository/assets.dart';
import '../repository/svn.dart';

part 'svn.g.dart';

@riverpod
class Svn extends _$Svn {
  @override
  SvnState build() {
    return const SvnState();
  }

  Future<Project> get currentPj async {
    final currentPjSnapshot = ref.watch(projectsPod).currentPj;
    if (currentPjSnapshot == null) {
      throw Exception('currentPjSnapshot is null!');
    }
    await _directoryExist(currentPjSnapshot);
    return Future.value(currentPjSnapshot);
  }

  Future<void> _directoryExist(Project? currentPjSnapshot) async {
    await Future.wait(
      <Future<bool>>[
        currentPjSnapshot?.backupDir.exists() ??
            Future.error(SystemExceptions().backupDirNotFound),
        currentPjSnapshot?.workingDir.exists() ??
            Future.error(SystemExceptions().workingDirNotFound),
      ],
    ).catchError((dynamic err) {
      debugPrint(err.toString());
    });
  }

  Future<ProcessResult> _runCommand({
    Directory? currentDirectory,
    required SvnExecs svnExecs,
    required List<String> args,
  }) async {
    currentDirectory ??= (await currentPj).workingDir;
    return SvnRepository.runCommand(
      currentDirectory: currentDirectory,
      svnExecs: svnExecs,
      args: args,
    );
  }

  Future<void> runStatus() async {
    debugPrint('>> runStatus << ');
    await _runCommand(
      svnExecs: SvnExecs.svn,
      args: ['status'],
    );
  }

  Future<void> runInfo() async {
    debugPrint('>> runInfo << ');
    await _runCommand(
      svnExecs: SvnExecs.svn,
      args: ['info'],
    );
  }

  Future<void> runLog() async {
    debugPrint('>> runLog << ');
    await SvnRepository(
      (await currentPj).workingDir,
    ).getRevisionsLog();
  }

  Future<void> runCreate() async {
    debugPrint('>> runCreate << ');
    await _runCommand(
      svnExecs: SvnExecs.svnAdmin,
      args: ['create', (await currentPj).backupDir.path],
    );
  }

  Future<void> runImport() async {
    debugPrint('>> runImport << ');
    final backupUri = (await currentPj).backupDir.uri.toString();

    await _runCommand(
      svnExecs: SvnExecs.svn,
      args: ['import', backupUri, '-m', 'import'],
    );
  }

  Future<void> runRename() async {
    debugPrint('>> runRename << ');
    final workingDir = (await currentPj).workingDir;
    Directory.current = (await currentPj).workingDir.parent;
    await workingDir.rename('_${workingDir.name}');
  }

  Future<void> runCheckout() async {
    debugPrint('>> runCheckout << ');
    final backupUri = (await currentPj).backupDir.uri.toString();
    await _runCommand(
      currentDirectory: (await currentPj).workingDir.parent,
      svnExecs: SvnExecs.svn,
      args: ['checkout', backupUri],
    );
  }

  Future<void> runStaging() async {
    debugPrint('>> runStaging << ');
    await _runCommand(
      svnExecs: SvnExecs.svn,
      args: ['add', '.', '--force'],
    );
  }

  Future<void> runCommit(String commitMsg) async {
    debugPrint('>> runCommit << ');
    await _runCommand(
      svnExecs: SvnExecs.svn,
      args: ['commit', '-m', '"$commitMsg"'],
    );
  }

  Future<void> update() async {
    debugPrint('>> update << ');
    await _runCommand(
      svnExecs: SvnExecs.svn,
      args: ['up'],
    );
  }

  Future<Directory> getBackupDir(Directory workingDir) async {
    final repoInfo = await SvnRepository(workingDir).getRepositoryInfo();

    final backupUri = repoInfo.repositoryRoot;
    final backupDir = Directory(backupUri.toFilePath());

    if (!await backupDir.exists()) {
      return Future.error(SystemExceptions().backupDirNotFound);
    }

    return backupDir;
  }

  Future<SvnRepositoryInfo> getRepositoryInfo() async {
    return SvnRepository((await currentPj).workingDir).getRepositoryInfo();
  }

  Future<List<SvnRevisionLog>> getPjSavePoints() async {
    return SvnRepository((await currentPj).workingDir).getRevisionsLog();
  }

  Future<List<SvnStatusEntry>> getPjStatus() async {
    return SvnRepository((await currentPj).workingDir).getSvnStatusEntries();
  }
}
