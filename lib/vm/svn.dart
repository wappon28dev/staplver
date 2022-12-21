// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:aibas/model/state.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/projects.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cmdSVNProvider =
    StateNotifierProvider<CmdSVNNotifier, CmdSVNState>(CmdSVNNotifier.new);

extension FileExtension on Directory {
  String get name {
    return path.split('\\').last;
  }
}

class CmdSVNNotifier extends StateNotifier<CmdSVNState> {
  CmdSVNNotifier(this.ref) : super(const CmdSVNState());

  final Ref ref;

  Future<bool> _directoryExist(ContentsState contentsState) async {
    final currentPj = ref.watch(projectsProvider).currentPj;

    var result = false;
    await Future.wait(<Future<bool>>[
      currentPj?.workingDir.exists() ?? Future.error('作業フォルダーが見つかりません'),
      currentPj?.backupDir.exists() ?? Future.error('バックアップフォルダーが見つかりません'),
    ]).then((value) => result = value[0]).catchError((dynamic err) {
      debugPrint(err.toString());
      result = false;
    });

    return result;
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

  Future<void> runStatus() async {
    final contentsState = ref.watch(contentsProvider);
    final currentPj = ref.watch(projectsProvider).currentPj;

    if (currentPj == null) return;
    if (!await _directoryExist(contentsState)) return;

    debugPrint('>> runStatus << ');

    Directory.current = currentPj.workingDir;
    await Process.run('svn', [
      'status',
    ]).then(_updateStdout);
  }

  Future<void> runInfo() async {
    final contentsState = ref.watch(contentsProvider);
    final currentPj = ref.watch(projectsProvider).currentPj;

    if (currentPj == null) return;
    if (!await _directoryExist(contentsState)) return;

    debugPrint('>> runInfo << ');

    Directory.current = currentPj.workingDir;
    await Process.run('svn', [
      'info',
    ]).then(_updateStdout);
  }

  Future<void> runLog() async {
    final contentsState = ref.watch(contentsProvider);
    final currentPj = ref.watch(projectsProvider).currentPj;

    if (currentPj == null) return;
    if (!await _directoryExist(contentsState)) return;

    debugPrint('>> runLog << ');

    Directory.current = currentPj.workingDir;
    await Process.run('svn', ['log', '--diff']).then(_updateStdout);
  }

  Future<void> runCreate() async {
    final contentsState = ref.watch(contentsProvider);
    final currentPj = ref.watch(projectsProvider).currentPj;

    if (currentPj == null) return;
    if (!await _directoryExist(contentsState)) return;

    debugPrint('>> runCreate << ');

    Directory.current = currentPj.backupDir;
    await Process.run('svnadmin', [
      'create',
      currentPj.backupDir.path,
    ]).then(_updateStdout);
  }

  Future<void> runImport() async {
    final contentsState = ref.watch(contentsProvider);
    final currentPj = ref.watch(projectsProvider).currentPj;

    if (currentPj == null) return;
    if (!await _directoryExist(contentsState)) return;

    debugPrint('>> runImport << ');

    final backupUri = currentPj.backupDir.uri.toString();
    Directory.current = currentPj.workingDir;

    await Process.run('svn', ['import', backupUri, '-m', '"import"'])
        .then(_updateStdout);
  }

  Future<void> runRename() async {
    final contentsState = ref.watch(contentsProvider);
    final currentPj = ref.watch(projectsProvider).currentPj;

    if (currentPj == null) return;
    if (!await _directoryExist(contentsState)) return;

    debugPrint('>> runRename << ');

    final workingDirName = currentPj.workingDir.name;
    Directory.current = currentPj.workingDir.parent;

    await currentPj.workingDir.rename('_$workingDirName');
  }

  Future<void> runCheckout() async {
    final currentPj = ref.watch(projectsProvider).currentPj;

    if (currentPj == null) return;

    debugPrint('>> runCheckout << ');

    final backupUri = currentPj.backupDir.uri.toString();
    Directory.current = currentPj.workingDir.parent;

    await Process.run('svn', ['checkout', backupUri]).then(_updateStdout);
  }

  Future<void> runStaging() async {
    final contentsState = ref.watch(contentsProvider);
    final currentPj = ref.watch(projectsProvider).currentPj;

    if (currentPj == null) return;
    if (!await _directoryExist(contentsState)) return;

    debugPrint('>> runStaging << ');

    Directory.current = currentPj.workingDir;

    await Process.run('svn', ['add', '.', '--force']).then(_updateStdout);
  }

  Future<void> runCommit(String commitMsg) async {
    final contentsState = ref.watch(contentsProvider);
    final currentPj = ref.watch(projectsProvider).currentPj;

    if (currentPj == null) return;
    if (!await _directoryExist(contentsState)) return;

    debugPrint('>> runCommit << ');

    Directory.current = currentPj.workingDir;

    await Process.run('svn', ['commit', '-m', '"$commitMsg"'])
        .then(_updateStdout);
  }

  Future<void> update() async {
    final contentsState = ref.watch(contentsProvider);
    final currentPj = ref.watch(projectsProvider).currentPj;

    if (currentPj == null) return;
    if (!await _directoryExist(contentsState)) return;

    debugPrint('>> update << ');

    Directory.current = currentPj.workingDir;

    await Process.run('svn', ['up']).then(_updateStdout);
  }
}
