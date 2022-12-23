import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'class.freezed.dart';

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
