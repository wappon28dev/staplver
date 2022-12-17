import 'dart:io';

import 'package:aibas/model/state.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contentsProvider = StateNotifierProvider<ContentsNotifier, ContentsState>(
  (ref) => ContentsNotifier(),
);

enum DragAndDropErrors {
  multiPathsProvided,
  isNotDirectory,
}

class ContentsNotifier extends StateNotifier<ContentsState> {
  ContentsNotifier() : super(const ContentsState());

  void updateWorkingDir(Directory? newWorkingDirectory) {
    debugPrint('newWorkingDirectory => $newWorkingDirectory');
    state = state.copyWith(workingDir: newWorkingDirectory);
  }

  void updateBackupDir(Directory? newBackupDirectory) {
    debugPrint('newBackupDirectory => $newBackupDirectory');
    state = state.copyWith(backupDir: newBackupDirectory);
  }

  Future<Directory> getSingleDirectory(List<String> paths) async {
    if (paths.length != 1) {
      return Future.error(DragAndDropErrors.multiPathsProvided);
    }

    var isDirectoryTemp = false;
    // ignore: avoid_slow_async_io
    await FileSystemEntity.isDirectory(paths[0])
        .then((bool isDirectory) => isDirectoryTemp = isDirectory);
    if (!isDirectoryTemp) {
      return Future.error(DragAndDropErrors.isNotDirectory);
    }
    return Directory(paths[0]);
  }
}
