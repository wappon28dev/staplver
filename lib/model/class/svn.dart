import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../constant.dart';

part 'svn.freezed.dart';
part 'svn.g.dart';

enum SvnActions {
  added('A', '追加', Icons.add_outlined, Colors.green),
  conflicted('C', '競合', Icons.error_outline, Colors.red),
  deleted('D', '削除', Icons.delete_outline, Colors.red),
  external('X', '外部', Icons.link, Colors.blue),
  ignored('I', '無視', Icons.block, Colors.grey),
  incomplete('!', '不完全', Icons.error_outline, Colors.red),
  missing('!', '削除', Icons.error_outline, Colors.red),
  modified('M', '変更', Icons.edit, Colors.orange),
  none(' ', 'なし', Icons.check, Colors.green),
  replaced('R', '置換', Icons.swap_horiz, Colors.blue),
  unversioned('?', '新規', Icons.new_releases_outlined, Colors.green);

  const SvnActions(this.marker, this.altName, this.icon, this.color);
  final String marker;
  final String altName;
  final IconData icon;
  final MaterialColor color;

  Chip chips(ColorScheme colorScheme) {
    final background = color.harmonizeWith(colorScheme.background);
    final foreground = background.onColor;
    return Chip(
      avatar: Icon(icon, color: foreground),
      label: Text(altName, style: TextStyle(color: foreground)),
      side: const BorderSide(color: Colors.transparent),
      backgroundColor: background,
    );
  }

  static SvnActions byName(String name) {
    return SvnActions.values.firstWhere((e) => e.marker == name);
  }
}

enum SvnKinds {
  file,
  dir,
}

@freezed
class SvnRepositoryInfo with _$SvnRepositoryInfo {
  const factory SvnRepositoryInfo({
    required SvnKinds kind,
    required String path,
    required int revision,
    required Uri url,
    required Uri relativeUrl,
    required Uri repositoryRoot,
    required String repositoryUuid,
    required String workingCopyRoot,
    required String workingCopySchedule,
    required String workingCopyDepth,
    required String author,
    required DateTime date,
  }) = _SvnRepositoryInfo;
  const SvnRepositoryInfo._();

  factory SvnRepositoryInfo.fromJson(Map<String, dynamic> json) =>
      _$SvnRepositoryInfoFromJson(json);
}

@freezed
class SvnRevisionPath with _$SvnRevisionPath {
  const factory SvnRevisionPath({
    required String filePath,
    required SvnActions action,
    required bool textMods,
    required bool propMods,
    required SvnKinds kind,
  }) = _SvnRevisionPath;
  const SvnRevisionPath._();

  factory SvnRevisionPath.fromJson(Map<String, dynamic> json) =>
      _$SvnRevisionPathFromJson(json);
}

@freezed
class SvnRevisionLog with _$SvnRevisionLog {
  const factory SvnRevisionLog({
    required int revisionIndex,
    required String author,
    required DateTime date,
    required String message,
    required List<SvnRevisionPath> paths,
  }) = _SvnRevisionLog;
  const SvnRevisionLog._();

  factory SvnRevisionLog.fromJson(Map<String, dynamic> json) =>
      _$SvnRevisionLogFromJson(json);
}

@freezed
class SvnStatusCommitInfo with _$SvnStatusCommitInfo {
  const factory SvnStatusCommitInfo({
    required String author,
    required int revision,
    required DateTime date,
  }) = _SvnStatusCommitInfo;
  const SvnStatusCommitInfo._();

  factory SvnStatusCommitInfo.fromJson(Map<String, dynamic> json) =>
      _$SvnStatusCommitInfoFromJson(json);
}

@freezed
class SvnStatusEntry with _$SvnStatusEntry {
  const factory SvnStatusEntry({
    required String path,
    required SvnActions item,
    required String props,
    int? revision,
    SvnStatusCommitInfo? commit,
  }) = _SvnStatusEntry;
  const SvnStatusEntry._();

  factory SvnStatusEntry.fromJson(Map<String, dynamic> json) =>
      _$SvnStatusEntryFromJson(json);
}
