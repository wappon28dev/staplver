import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class PageState with _$PageState {
  const factory PageState({
    @Default(0) int navbarIndex,
    @Default('') String currentPjName,
  }) = _PageState;
}

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool useDynamicColor,
  }) = _ThemeState;
}

enum DirectoryKinds { working, backup }

@freezed
class ContentsState with _$ContentsState {
  const factory ContentsState({
    @Default(DirectoryKinds.working) DirectoryKinds directoryKinds,
    Directory? workingDirectory,
    Directory? backupDirectory,
  }) = _ContentsState;
}
