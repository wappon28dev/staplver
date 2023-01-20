import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app.freezed.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String name,
    required Directory workingDir,
    required Directory backupDir,
    required int backupMin,
  }) = _Project;
}

@freezed
class Destination with _$Destination {
  const factory Destination({
    required Icon icon,
    required Icon selectedIcon,
    required String label,
    required VoidCallback runInit,
  }) = _Destination;
}

@freezed
class WizardComponents with _$WizardComponents {
  const factory WizardComponents({
    required String title,
    required VoidCallback runInit,
    required IconData icon,
    required Widget screen,
  }) = _WizardComponents;
}

@freezed
class ExceptionAction with _$ExceptionAction {
  const factory ExceptionAction({
    required String title,
    IconData? icon,
    void Function(BuildContext context, WidgetRef ref)? onClick,
    @Default(false) bool isPrimary,
  }) = _ExceptionAction;
}

@freezed
class AIBASException with _$AIBASException implements Exception {
  const factory AIBASException({
    required String message,
    @Default(Icons.error_outline) IconData icon,
    List<ExceptionAction>? actions,
    @Default(false) bool needShowAsBanner,
  }) = _AIBASException;
}
