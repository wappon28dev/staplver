// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:aibas/model/state.dart';
import 'package:aibas/vm/contents.dart';
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
    var result = false;
    await Future.wait(<Future<bool>>[
      contentsState.workingDirectory?.exists() ??
          Future.error('作業フォルダーが見つかりません'),
      contentsState.backupDirectory?.exists() ??
          Future.error('バックアップフォルダーが見つかりません'),
    ]).then((value) => result = value[0]).catchError((dynamic err) {
      if (kDebugMode) print(err);
      result = false;
    });

    return result;
  }

  void _updateStdout(ProcessResult process) {
    final stdout = process.stdout.toString();
    final stderr = process.stderr.toString();

    if (kDebugMode) {
      print('out => $stdout');
      print('err => $stderr');
    }

    state = state.copyWith(stdout: stdout + stderr);
  }

  Future<void> runCreate() async {
    final contentsState = ref.watch(contentsProvider);
    if (!await _directoryExist(contentsState)) return;

    Directory.current = contentsState.backupDirectory;
    await Process.run('svnadmin', [
      'create',
      contentsState.backupDirectory?.path ?? '',
    ]).then(_updateStdout);
  }

  Future<void> runImport() async {
    final contentsState = ref.watch(contentsProvider);
    if (!await _directoryExist(contentsState)) return;

    final backupUri = contentsState.backupDirectory?.uri.toString();
    print(backupUri);

    Directory.current = contentsState.workingDirectory;

    await Process.run('svn', ['import', backupUri ?? '', '-m', '"import"'])
        .then(_updateStdout);
  }

  Future<void> runRename() async {
    final contentsState = ref.watch(contentsProvider);
    if (!await _directoryExist(contentsState)) return;

    final workingDirName = contentsState.workingDirectory?.name;
    Directory.current = contentsState.workingDirectory?.parent;

    await contentsState.workingDirectory?.rename('_$workingDirName');
  }

  Future<void> runCheckout() async {
    final contentsState = ref.watch(contentsProvider);

    final backupUri = contentsState.backupDirectory?.uri.toString();
    Directory.current = contentsState.workingDirectory?.parent;

    await Process.run('svn', ['checkout', backupUri ?? '']).then(_updateStdout);
  }

  Future<void> runStaging() async {
    final contentsState = ref.watch(contentsProvider);
    if (!await _directoryExist(contentsState)) return;

    Directory.current = contentsState.workingDirectory;

    await Process.run('svn', ['add', '.', '--force']).then(_updateStdout);
  }

  Future<void> runCommit(String commitMsg) async {
    final contentsState = ref.watch(contentsProvider);
    if (!await _directoryExist(contentsState)) return;

    Directory.current = contentsState.workingDirectory;

    await Process.run('svn', ['commit', '-m', '"$commitMsg"'])
        .then(_updateStdout);
  }

  Future<void> update() async {
    final contentsState = ref.watch(contentsProvider);
    if (!await _directoryExist(contentsState)) return;

    Directory.current = contentsState.workingDirectory;

    await Process.run('svn', ['up']).then(_updateStdout);
  }
}
