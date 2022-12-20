import 'dart:io';

import 'package:aibas/model/data/class.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';
// part 'state.g.dart';

@freezed
class PageState with _$PageState {
  const factory PageState({
    @Default(0) int navbarIndex,
    @Default(-1) int createPjIndex,
  }) = _PageState;
}

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool useDynamicColor,
  }) = _ThemeState;
}

enum DirectoryKinds { defaultWorking, working, backup, none }

@freezed
class ContentsState with _$ContentsState {
  const factory ContentsState({
    Directory? defaultBackupDir,
    @Default(DirectoryKinds.none) DirectoryKinds dragAndDropSendTo,
  }) = _ContentsState;
}

@freezed
class CmdSVNState with _$CmdSVNState {
  const factory CmdSVNState({
    @Default('') String stdout,
    @Default(0) double progress,
  }) = _CmdSVNState;
}

@freezed
class ProjectsState with _$ProjectsState {
  const factory ProjectsState({
    List<Project>? savedProjects,
    @Default(0) int currentPjIndex,
  }) = _ProjectsState;
  const ProjectsState._();

  Project? get currentPj => savedProjects?[currentPjIndex];
}
