import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/state.dart';
import 'log.dart';

part 'contents.g.dart';

enum DragAndDropErrors {
  multiPathsProvided,
  isNotDirectory,
}

@Riverpod(keepAlive: true)
class Contents extends _$Contents {
  @override
  ContentsState build() {
    return const ContentsState();
  }

  void updateDefaultBackupDir(Directory? newDefaultBackupDir) {
    log.t('newDefaultBackupDir:\n  $newDefaultBackupDir');
    state = state.copyWith(defaultBackupDir: newDefaultBackupDir);
  }

  void updateDragAndDropCallback(
    void Function(Directory)? newDragAndDropCallback,
  ) {
    log.t('newDragAndDropCallback:\n  $newDragAndDropCallback');
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
