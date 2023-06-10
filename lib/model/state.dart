import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'class/app.dart';

part 'state.freezed.dart';

@freezed
class LogState with _$LogState {
  const factory LogState({
    @Default(<String>[]) List<String> logs,
  }) = _LogState;
}

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
class AppThemeState with _$AppThemeState {
  const factory AppThemeState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool useDynamicColor,
  }) = _AppThemeState;
}

@freezed
class ContentsState with _$ContentsState {
  const factory ContentsState({
    Directory? defaultBackupDir,
    void Function(Directory)? dragAndDropCallback,
  }) = _ContentsState;
}

@freezed
class SvnState with _$SvnState {
  const factory SvnState({
    @Default('') String status,
  }) = _SvnState;
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
