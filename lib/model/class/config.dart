import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';
part 'config.g.dart';

@freezed
class PjConfig with _$PjConfig {
  const factory PjConfig({
    required String name,
    required int backupMin,
  }) = _PjConfig;
  const PjConfig._();

  factory PjConfig.fromJson(Map<String, dynamic> json) =>
      _$PjConfigFromJson(json);
}

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    required Map<String, String> savedProjectPath,
    required String? defaultBackupDir,
    required int themeMode,
    required bool useDynamicColor,
  }) = _AppConfig;
  const AppConfig._();

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
}
