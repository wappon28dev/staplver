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
  missing('!', '削除', Icons.error_outline, Colors.red),
  modified('M', '変更', Icons.edit, Colors.orange),
  none(' ', 'なし', Icons.check, Colors.green),
  normal(' ', 'なし', Icons.check, Colors.green),
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

/// Repository (= Project) の情報
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

/// History での 1 つの変更されたファイルを指す.
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

/// `svn log` の結果
///
/// Project での 1 つの履歴(= History) を指す.
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

/// Projectの状態で過去にコミットがあった場合のリビジョン情報
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

/// `svn status` の結果
///
/// Project の状態を指す.
@freezed
class SvnStatusEntry with _$SvnStatusEntry {
  const factory SvnStatusEntry({
    required String path,
    required SvnActions action,
    required String props,
    int? revision,
    bool? copied,
    String? movedTo,
    String? movedFrom,
    SvnStatusCommitInfo? commit,
  }) = _SvnStatusEntry;
  const SvnStatusEntry._();

  factory SvnStatusEntry.fromJson(Map<String, dynamic> json) =>
      _$SvnStatusEntryFromJson(json);
}
