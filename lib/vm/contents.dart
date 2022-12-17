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

  void updateDirectoryKinds(DirectoryKinds newDirectoryKinds) {
    if (kDebugMode) print('newDirectoryKinds => $newDirectoryKinds');
    state = state.copyWith(directoryKinds: newDirectoryKinds);
  }

  void updateWorkingDirectory(Directory newWorkingDirectory) {
    if (kDebugMode) print('newWorkingDirectory => $newWorkingDirectory');
    state = state.copyWith(workingDirectory: newWorkingDirectory);
  }

  void updateBackupDirectory(Directory newBackupDirectory) {
    if (kDebugMode) print('newBackupDirectory => $newBackupDirectory');
    state = state.copyWith(backupDirectory: newBackupDirectory);
  }

  Future<Directory> _getSingleDirectory(List<String> paths) async {
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

  Future<void> handleDragAndDrop(List<String> paths) async {
    await _getSingleDirectory(paths).then((directory) {
      switch (state.directoryKinds) {
        case DirectoryKinds.backup:
          updateBackupDirectory(directory);
          break;

        case DirectoryKinds.working:
          updateWorkingDirectory(directory);
          break;
      }
    });
  }
}
