// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:aibas/model/constant.dart';
import 'package:aibas/repository/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/class/app.dart';
import '../model/class/svn.dart';
import '../model/error/exception.dart';
import '../model/state.dart';
import '../repository/svn.dart';
import '../vm/contents.dart';
import '../vm/projects.dart';

final cmdSVNProvider =
    StateNotifierProvider<CmdSVNNotifier, CmdSVNState>(CmdSVNNotifier.new);

class CmdSVNNotifier extends StateNotifier<CmdSVNState> {
  CmdSVNNotifier(this.ref) : super(const CmdSVNState());

  final Ref ref;

  ContentsState get contentsState => ref.watch(contentsProvider);

  Future<Project> get currentPj async {
    final currentPjSnapshot = ref.watch(projectsProvider).currentPj;
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
            Future.error(AIBASExceptions().backupDirNotFound),
        currentPjSnapshot?.workingDir.exists() ??
            Future.error(AIBASExceptions().workingDirNotFound),
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
    return SvnRepository().runCommand(
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
    await SvnRepository().getRevisionsLog(
      (await currentPj).workingDir,
    );
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
    final repoInfo = await SvnRepository().getRepositoryInfo(workingDir);

    final backupUri = repoInfo.repositoryRoot;
    final backupDir = Directory(backupUri.toFilePath());

    if (!await backupDir.exists()) {
      return Future.error(AIBASExceptions().backupDirNotFound);
    }

    return backupDir;
  }

  Future<SvnRepositoryInfo> getRepositoryInfo() async {
    return SvnRepository().getRepositoryInfo((await currentPj).workingDir);
  }

  Future<List<SvnRevisionLog>> getSavePointInfo() async {
    return SvnRepository().getRevisionsLog((await currentPj).workingDir);
  }

  Future<List<SvnStatusEntry>> getPjStatus() async {
    return SvnRepository().getSvnStatusEntries((await currentPj).workingDir);
  }
}
