// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:aibas/model/class/app.dart';
import 'package:aibas/model/constant.dart';
import 'package:aibas/model/error/exception.dart';
import 'package:aibas/model/state.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/projects.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/svn.dart';

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

  void _updateStdout(ProcessResult process) {
    final stdout = process.stdout.toString();
    final stderr = process.stderr.toString();

    if (kDebugMode) {
      print('out => \n $stdout');
      print('err => \n $stderr');
    }

    state = state.copyWith(stdout: stdout + stderr);
  }

  Future<void> _runCommand({
    Directory? currentDirectory,
    required SVNBaseCmd baseCommand,
    required List<String> args,
  }) async {
    currentDirectory ??= (await currentPj).workingDir;
    await Process.run(
      baseCommand.name,
      args,
      workingDirectory: currentDirectory.path,
    ).then(_updateStdout);
  }

  Future<Directory> getBackupDir(Directory workingDir) async {
    await _runCommand(
      currentDirectory: workingDir,
      baseCommand: SVNBaseCmd.svn,
      args: ['info'],
    );

    final reg = RegExp(r'(?<=URL: )(.*)');
    final uriStr = reg.firstMatch(state.stdout)?.group(0);

    if (uriStr == null) return Future.error(AIBASExceptions().dirNotSVNRepo);
    final backupDir = Uri.parse(uriStr).toFilePath();
    if (!await Directory(backupDir).exists()) {
      return Future.error(AIBASExceptions().backupDirNotFound);
    }

    return Directory(backupDir);
  }

  Future<void> runStatus() async {
    debugPrint('>> runStatus << ');
    await _runCommand(
      baseCommand: SVNBaseCmd.svn,
      args: ['status'],
    );
  }

  Future<void> runInfo() async {
    debugPrint('>> runInfo << ');
    await _runCommand(
      baseCommand: SVNBaseCmd.svn,
      args: ['info'],
    );
  }

  Future<void> runLog() async {
    debugPrint('>> runLog << ');
    await _runCommand(
      baseCommand: SVNBaseCmd.svn,
      args: ['log', '-v', '--xml'],
    );
  }

  Future<void> runCreate() async {
    debugPrint('>> runCreate << ');
    await _runCommand(
      baseCommand: SVNBaseCmd.svnadmin,
      args: ['create', (await currentPj).backupDir.path],
    );
  }

  Future<void> runImport() async {
    debugPrint('>> runImport << ');
    final backupUri = (await currentPj).backupDir.uri.toString();

    await _runCommand(
      baseCommand: SVNBaseCmd.svn,
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
      baseCommand: SVNBaseCmd.svn,
      args: ['checkout', backupUri],
    );
  }

  Future<void> runStaging() async {
    debugPrint('>> runStaging << ');
    await _runCommand(
      baseCommand: SVNBaseCmd.svn,
      args: ['add', '.', '--force'],
    );
  }

  Future<void> runCommit(String commitMsg) async {
    debugPrint('>> runCommit << ');
    await _runCommand(
      baseCommand: SVNBaseCmd.svn,
      args: ['commit', '-m', '"$commitMsg"'],
    );
  }

  Future<void> update() async {
    debugPrint('>> update << ');
    await _runCommand(
      baseCommand: SVNBaseCmd.svn,
      args: ['up'],
    );
  }
}
