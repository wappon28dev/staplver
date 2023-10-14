import 'dart:io';

import 'package:cross_file/cross_file.dart';
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

  static Future<Directory> getSingleDirectory(List<XFile> files) async {
    if (files.length != 1) {
      return Future.error(DragAndDropErrors.multiPathsProvided);
    }

    // ignore: avoid_slow_async_io
    final isDirectory = await FileSystemEntity.isDirectory(files[0].path);

    if (!isDirectory) {
      return Future.error(DragAndDropErrors.isNotDirectory);
    }

    return Directory(files[0].path);
  }
}
