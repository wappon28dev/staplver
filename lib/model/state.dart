import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';
part 'state.g.dart';

@freezed
class PageState with _$PageState {
  const factory PageState({
    @Default(0) int navbarIndex,
    @Default('') String currentPjName,
    @Default(0) int createPjIndex,
  }) = _PageState;
}

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool useDynamicColor,
  }) = _ThemeState;
}

enum DirectoryKinds { working, backup, none }

@freezed
class ContentsState with _$ContentsState {
  const factory ContentsState({
    Directory? workingDir,
    Directory? backupDir,
  }) = _ContentsState;
}

@freezed
class CmdSVNState with _$CmdSVNState {
  const factory CmdSVNState({
    @Default('') String stdout,
  }) = _CmdSVNState;
}

@freezed
class ConfigState with _$ConfigState {
  const factory ConfigState({
    @Default({'': ''}) Map<String, String> projectDirectories,
  }) = _ConfigState;
  const ConfigState._();

  factory ConfigState.fromJson(Map<String, dynamic> json) =>
      _$ConfigStateFromJson(json);
}
