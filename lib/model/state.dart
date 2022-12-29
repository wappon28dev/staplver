import 'dart:io';

import 'package:aibas/model/data/class.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class PageState with _$PageState {
  const factory PageState({
    @Default(0) int navbarIndex,
    @Default(0) int wizardIndex,
    @Default(false) bool askWhenQuit,
    @Default(0.3) double progress,
    @Default(true) bool isVisibleProgressBar,
  }) = _PageState;
}

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool useDynamicColor,
  }) = _ThemeState;
}

@freezed
class ContentsState with _$ContentsState {
  const factory ContentsState({
    Directory? defaultBackupDir,
    void Function(Directory)? dragAndDropCallback,
  }) = _ContentsState;
}

@freezed
class CmdSVNState with _$CmdSVNState {
  const factory CmdSVNState({
    @Default('') String stdout,
  }) = _CmdSVNState;
}

@freezed
class ProjectsState with _$ProjectsState {
  const factory ProjectsState({
    @Default(<Project>[]) List<Project> savedProjects,
    @Default(0) int currentPjIndex,
  }) = _ProjectsState;
  const ProjectsState._();

  Project? get currentPj {
    if (savedProjects.isEmpty) return null;
    return savedProjects[currentPjIndex];
  }
}
