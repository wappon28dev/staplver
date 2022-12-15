import 'dart:io';

import 'package:aibas/model/state.dart';
import 'package:aibas/vm/contents.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cmdSVNProvider =
    StateNotifierProvider<CmdSVNNotifier, CmdSVNState>(CmdSVNNotifier.new);

class CmdSVNNotifier extends StateNotifier<CmdSVNState> {
  CmdSVNNotifier(this.ref) : super(const CmdSVNState());

  final Ref ref;

  void _updateStdout(String newStdout) {
    if (kDebugMode) print('newStdout');
    state = state.copyWith(stdout: newStdout);
  }

  void runCreate() async {
    final contentsState = ref.watch(contentsProvider);

    if (contentsState.backupDirectory == null) return;

    Directory.current = contentsState.backupDirectory;
    await Process.run('svnadmin', [
      'create',
      contentsState.backupDirectory?.path ?? '',
    ]).then((process) => print(process.stderr));
  }
}
