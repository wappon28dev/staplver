import 'dart:io';

import 'package:aibas/model/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contentsProvider = StateNotifierProvider<ContentsNotifier, ContentsState>(
  (ref) => ContentsNotifier(),
);

class ContentsNotifier extends StateNotifier<ContentsState> {
  ContentsNotifier() : super(const ContentsState());

  Future<void> handleDragAndDrop(List<String> paths) async {
    if (paths.length != 1) return;

    var isDirectoryTemp = false;
    // ignore: avoid_slow_async_io
    await FileSystemEntity.isDirectory(paths[0])
        .then((bool isDirectory) => isDirectoryTemp = isDirectory);
    if (!isDirectoryTemp) return;

    final targetDirectory = Directory(paths[0]);
    updateTargetDirectory(targetDirectory);
  }

  void updateTargetDirectory(Directory newTargetDirectory) {
    print('newTargetDirectory => $newTargetDirectory');
    state = state.copyWith(targetDirectory: newTargetDirectory);
  }
}
