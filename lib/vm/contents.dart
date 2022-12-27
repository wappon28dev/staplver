import 'dart:io';

import 'package:aibas/model/state.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contentsProvider = StateNotifierProvider<ContentsNotifier, ContentsState>(
  ContentsNotifier.new,
);

enum DragAndDropErrors {
  multiPathsProvided,
  isNotDirectory,
}

class ContentsNotifier extends StateNotifier<ContentsState> {
  ContentsNotifier(this.ref) : super(const ContentsState());

  final Ref ref;

  void updateDefaultBackupDir(Directory? newDefaultBackupDir) {
    debugPrint('newDefaultBackupDir => $newDefaultBackupDir');
    state = state.copyWith(defaultBackupDir: newDefaultBackupDir);
  }

  void updateDragAndDropCallback(
    void Function(Directory)? newDragAndDropCallback,
  ) {
    debugPrint('newDragAndDropCallback => $newDragAndDropCallback');
    state = state.copyWith(dragAndDropCallback: newDragAndDropCallback);
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

  Future<void> handleDragAndDrop(List<String> paths) async {
    if (state.dragAndDropCallback == null) return;

    state.dragAndDropCallback!(await getSingleDirectory(paths));
  }
}
