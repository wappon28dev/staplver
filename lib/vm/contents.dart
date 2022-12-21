import 'dart:io';

import 'package:aibas/model/state.dart';
import 'package:aibas/view/routes/fab/create_pj.dart';
import 'package:aibas/vm/svn.dart';

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

  void updateDragAndDropSendTo(DirectoryKinds newDragAndDropSendTo) {
    debugPrint('newDragAndDropSendTo => $newDragAndDropSendTo');
    state = state.copyWith(dragAndDropSendTo: newDragAndDropSendTo);
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
    final dir = await getSingleDirectory(paths);
    switch (state.dragAndDropSendTo) {
      case DirectoryKinds.none:
        return;

      case DirectoryKinds.defaultWorking:
        updateDefaultBackupDir(dir);
        break;

      case DirectoryKinds.backup:
        ref.read(backupDirProvider.notifier).state = dir;
        break;

      case DirectoryKinds.working:
        ref.read(workingDirProvider.notifier).state = dir;
        ref.read(pjNameProvider.notifier).state = dir.name;
    }
  }
}
