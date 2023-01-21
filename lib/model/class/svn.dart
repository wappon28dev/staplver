import 'package:freezed_annotation/freezed_annotation.dart';

part 'svn.freezed.dart';
part 'svn.g.dart';

enum SvnActions {
  added('A'),
  conflicted('C'),
  deleted('D'),
  external('X'),
  ignored('I'),
  incomplete('!'),
  missing('!'),
  modified('M'),
  none(' '),
  replaced('R'),
  unversioned('?');

  const SvnActions(this.marker);
  final String marker;

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
