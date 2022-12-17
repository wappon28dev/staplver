// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PageState {
  int get navbarIndex => throw _privateConstructorUsedError;
  String get currentPjName => throw _privateConstructorUsedError;
  int get createPjIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PageStateCopyWith<PageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageStateCopyWith<$Res> {
  factory $PageStateCopyWith(PageState value, $Res Function(PageState) then) =
      _$PageStateCopyWithImpl<$Res, PageState>;
  @useResult
  $Res call({int navbarIndex, String currentPjName, int createPjIndex});
}

/// @nodoc
class _$PageStateCopyWithImpl<$Res, $Val extends PageState>
    implements $PageStateCopyWith<$Res> {
  _$PageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navbarIndex = null,
    Object? currentPjName = null,
    Object? createPjIndex = null,
  }) {
    return _then(_value.copyWith(
      navbarIndex: null == navbarIndex
          ? _value.navbarIndex
          : navbarIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentPjName: null == currentPjName
          ? _value.currentPjName
          : currentPjName // ignore: cast_nullable_to_non_nullable
              as String,
      createPjIndex: null == createPjIndex
          ? _value.createPjIndex
          : createPjIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PageStateCopyWith<$Res> implements $PageStateCopyWith<$Res> {
  factory _$$_PageStateCopyWith(
          _$_PageState value, $Res Function(_$_PageState) then) =
      __$$_PageStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int navbarIndex, String currentPjName, int createPjIndex});
}

/// @nodoc
class __$$_PageStateCopyWithImpl<$Res>
    extends _$PageStateCopyWithImpl<$Res, _$_PageState>
    implements _$$_PageStateCopyWith<$Res> {
  __$$_PageStateCopyWithImpl(
      _$_PageState _value, $Res Function(_$_PageState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navbarIndex = null,
    Object? currentPjName = null,
    Object? createPjIndex = null,
  }) {
    return _then(_$_PageState(
      navbarIndex: null == navbarIndex
          ? _value.navbarIndex
          : navbarIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentPjName: null == currentPjName
          ? _value.currentPjName
          : currentPjName // ignore: cast_nullable_to_non_nullable
              as String,
      createPjIndex: null == createPjIndex
          ? _value.createPjIndex
          : createPjIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_PageState with DiagnosticableTreeMixin implements _PageState {
  const _$_PageState(
      {this.navbarIndex = 0, this.currentPjName = '', this.createPjIndex = 0});

  @override
  @JsonKey()
  final int navbarIndex;
  @override
  @JsonKey()
  final String currentPjName;
  @override
  @JsonKey()
  final int createPjIndex;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PageState(navbarIndex: $navbarIndex, currentPjName: $currentPjName, createPjIndex: $createPjIndex)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PageState'))
      ..add(DiagnosticsProperty('navbarIndex', navbarIndex))
      ..add(DiagnosticsProperty('currentPjName', currentPjName))
      ..add(DiagnosticsProperty('createPjIndex', createPjIndex));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PageState &&
            (identical(other.navbarIndex, navbarIndex) ||
                other.navbarIndex == navbarIndex) &&
            (identical(other.currentPjName, currentPjName) ||
                other.currentPjName == currentPjName) &&
            (identical(other.createPjIndex, createPjIndex) ||
                other.createPjIndex == createPjIndex));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, navbarIndex, currentPjName, createPjIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PageStateCopyWith<_$_PageState> get copyWith =>
      __$$_PageStateCopyWithImpl<_$_PageState>(this, _$identity);
}

abstract class _PageState implements PageState {
  const factory _PageState(
      {final int navbarIndex,
      final String currentPjName,
      final int createPjIndex}) = _$_PageState;

  @override
  int get navbarIndex;
  @override
  String get currentPjName;
  @override
  int get createPjIndex;
  @override
  @JsonKey(ignore: true)
  _$$_PageStateCopyWith<_$_PageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ThemeState {
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  bool get useDynamicColor => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ThemeStateCopyWith<ThemeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeStateCopyWith<$Res> {
  factory $ThemeStateCopyWith(
          ThemeState value, $Res Function(ThemeState) then) =
      _$ThemeStateCopyWithImpl<$Res, ThemeState>;
  @useResult
  $Res call({ThemeMode themeMode, bool useDynamicColor});
}

/// @nodoc
class _$ThemeStateCopyWithImpl<$Res, $Val extends ThemeState>
    implements $ThemeStateCopyWith<$Res> {
  _$ThemeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? useDynamicColor = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      useDynamicColor: null == useDynamicColor
          ? _value.useDynamicColor
          : useDynamicColor // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ThemeStateCopyWith<$Res>
    implements $ThemeStateCopyWith<$Res> {
  factory _$$_ThemeStateCopyWith(
          _$_ThemeState value, $Res Function(_$_ThemeState) then) =
      __$$_ThemeStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ThemeMode themeMode, bool useDynamicColor});
}

/// @nodoc
class __$$_ThemeStateCopyWithImpl<$Res>
    extends _$ThemeStateCopyWithImpl<$Res, _$_ThemeState>
    implements _$$_ThemeStateCopyWith<$Res> {
  __$$_ThemeStateCopyWithImpl(
      _$_ThemeState _value, $Res Function(_$_ThemeState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? useDynamicColor = null,
  }) {
    return _then(_$_ThemeState(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      useDynamicColor: null == useDynamicColor
          ? _value.useDynamicColor
          : useDynamicColor // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ThemeState with DiagnosticableTreeMixin implements _ThemeState {
  const _$_ThemeState(
      {this.themeMode = ThemeMode.system, this.useDynamicColor = true});

  @override
  @JsonKey()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final bool useDynamicColor;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ThemeState(themeMode: $themeMode, useDynamicColor: $useDynamicColor)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ThemeState'))
      ..add(DiagnosticsProperty('themeMode', themeMode))
      ..add(DiagnosticsProperty('useDynamicColor', useDynamicColor));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ThemeState &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.useDynamicColor, useDynamicColor) ||
                other.useDynamicColor == useDynamicColor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, themeMode, useDynamicColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ThemeStateCopyWith<_$_ThemeState> get copyWith =>
      __$$_ThemeStateCopyWithImpl<_$_ThemeState>(this, _$identity);
}

abstract class _ThemeState implements ThemeState {
  const factory _ThemeState(
      {final ThemeMode themeMode, final bool useDynamicColor}) = _$_ThemeState;

  @override
  ThemeMode get themeMode;
  @override
  bool get useDynamicColor;
  @override
  @JsonKey(ignore: true)
  _$$_ThemeStateCopyWith<_$_ThemeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ContentsState {
  DirectoryKinds get directoryKinds => throw _privateConstructorUsedError;
  Directory? get workingDirectory => throw _privateConstructorUsedError;
  Directory? get backupDirectory => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ContentsStateCopyWith<ContentsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentsStateCopyWith<$Res> {
  factory $ContentsStateCopyWith(
          ContentsState value, $Res Function(ContentsState) then) =
      _$ContentsStateCopyWithImpl<$Res, ContentsState>;
  @useResult
  $Res call(
      {DirectoryKinds directoryKinds,
      Directory? workingDirectory,
      Directory? backupDirectory});
}

/// @nodoc
class _$ContentsStateCopyWithImpl<$Res, $Val extends ContentsState>
    implements $ContentsStateCopyWith<$Res> {
  _$ContentsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? directoryKinds = null,
    Object? workingDirectory = freezed,
    Object? backupDirectory = freezed,
  }) {
    return _then(_value.copyWith(
      directoryKinds: null == directoryKinds
          ? _value.directoryKinds
          : directoryKinds // ignore: cast_nullable_to_non_nullable
              as DirectoryKinds,
      workingDirectory: freezed == workingDirectory
          ? _value.workingDirectory
          : workingDirectory // ignore: cast_nullable_to_non_nullable
              as Directory?,
      backupDirectory: freezed == backupDirectory
          ? _value.backupDirectory
          : backupDirectory // ignore: cast_nullable_to_non_nullable
              as Directory?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ContentsStateCopyWith<$Res>
    implements $ContentsStateCopyWith<$Res> {
  factory _$$_ContentsStateCopyWith(
          _$_ContentsState value, $Res Function(_$_ContentsState) then) =
      __$$_ContentsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DirectoryKinds directoryKinds,
      Directory? workingDirectory,
      Directory? backupDirectory});
}

/// @nodoc
class __$$_ContentsStateCopyWithImpl<$Res>
    extends _$ContentsStateCopyWithImpl<$Res, _$_ContentsState>
    implements _$$_ContentsStateCopyWith<$Res> {
  __$$_ContentsStateCopyWithImpl(
      _$_ContentsState _value, $Res Function(_$_ContentsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? directoryKinds = null,
    Object? workingDirectory = freezed,
    Object? backupDirectory = freezed,
  }) {
    return _then(_$_ContentsState(
      directoryKinds: null == directoryKinds
          ? _value.directoryKinds
          : directoryKinds // ignore: cast_nullable_to_non_nullable
              as DirectoryKinds,
      workingDirectory: freezed == workingDirectory
          ? _value.workingDirectory
          : workingDirectory // ignore: cast_nullable_to_non_nullable
              as Directory?,
      backupDirectory: freezed == backupDirectory
          ? _value.backupDirectory
          : backupDirectory // ignore: cast_nullable_to_non_nullable
              as Directory?,
    ));
  }
}

/// @nodoc

class _$_ContentsState with DiagnosticableTreeMixin implements _ContentsState {
  const _$_ContentsState(
      {this.directoryKinds = DirectoryKinds.working,
      this.workingDirectory,
      this.backupDirectory});

  @override
  @JsonKey()
  final DirectoryKinds directoryKinds;
  @override
  final Directory? workingDirectory;
  @override
  final Directory? backupDirectory;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ContentsState(directoryKinds: $directoryKinds, workingDirectory: $workingDirectory, backupDirectory: $backupDirectory)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ContentsState'))
      ..add(DiagnosticsProperty('directoryKinds', directoryKinds))
      ..add(DiagnosticsProperty('workingDirectory', workingDirectory))
      ..add(DiagnosticsProperty('backupDirectory', backupDirectory));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ContentsState &&
            (identical(other.directoryKinds, directoryKinds) ||
                other.directoryKinds == directoryKinds) &&
            (identical(other.workingDirectory, workingDirectory) ||
                other.workingDirectory == workingDirectory) &&
            (identical(other.backupDirectory, backupDirectory) ||
                other.backupDirectory == backupDirectory));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, directoryKinds, workingDirectory, backupDirectory);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ContentsStateCopyWith<_$_ContentsState> get copyWith =>
      __$$_ContentsStateCopyWithImpl<_$_ContentsState>(this, _$identity);
}

abstract class _ContentsState implements ContentsState {
  const factory _ContentsState(
      {final DirectoryKinds directoryKinds,
      final Directory? workingDirectory,
      final Directory? backupDirectory}) = _$_ContentsState;

  @override
  DirectoryKinds get directoryKinds;
  @override
  Directory? get workingDirectory;
  @override
  Directory? get backupDirectory;
  @override
  @JsonKey(ignore: true)
  _$$_ContentsStateCopyWith<_$_ContentsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CmdSVNState {
  String get stdout => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CmdSVNStateCopyWith<CmdSVNState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CmdSVNStateCopyWith<$Res> {
  factory $CmdSVNStateCopyWith(
          CmdSVNState value, $Res Function(CmdSVNState) then) =
      _$CmdSVNStateCopyWithImpl<$Res, CmdSVNState>;
  @useResult
  $Res call({String stdout});
}

/// @nodoc
class _$CmdSVNStateCopyWithImpl<$Res, $Val extends CmdSVNState>
    implements $CmdSVNStateCopyWith<$Res> {
  _$CmdSVNStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stdout = null,
  }) {
    return _then(_value.copyWith(
      stdout: null == stdout
          ? _value.stdout
          : stdout // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CmdSVNStateCopyWith<$Res>
    implements $CmdSVNStateCopyWith<$Res> {
  factory _$$_CmdSVNStateCopyWith(
          _$_CmdSVNState value, $Res Function(_$_CmdSVNState) then) =
      __$$_CmdSVNStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String stdout});
}

/// @nodoc
class __$$_CmdSVNStateCopyWithImpl<$Res>
    extends _$CmdSVNStateCopyWithImpl<$Res, _$_CmdSVNState>
    implements _$$_CmdSVNStateCopyWith<$Res> {
  __$$_CmdSVNStateCopyWithImpl(
      _$_CmdSVNState _value, $Res Function(_$_CmdSVNState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stdout = null,
  }) {
    return _then(_$_CmdSVNState(
      stdout: null == stdout
          ? _value.stdout
          : stdout // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_CmdSVNState with DiagnosticableTreeMixin implements _CmdSVNState {
  const _$_CmdSVNState({this.stdout = ''});

  @override
  @JsonKey()
  final String stdout;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CmdSVNState(stdout: $stdout)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CmdSVNState'))
      ..add(DiagnosticsProperty('stdout', stdout));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CmdSVNState &&
            (identical(other.stdout, stdout) || other.stdout == stdout));
  }

  @override
  int get hashCode => Object.hash(runtimeType, stdout);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CmdSVNStateCopyWith<_$_CmdSVNState> get copyWith =>
      __$$_CmdSVNStateCopyWithImpl<_$_CmdSVNState>(this, _$identity);
}

abstract class _CmdSVNState implements CmdSVNState {
  const factory _CmdSVNState({final String stdout}) = _$_CmdSVNState;

  @override
  String get stdout;
  @override
  @JsonKey(ignore: true)
  _$$_CmdSVNStateCopyWith<_$_CmdSVNState> get copyWith =>
      throw _privateConstructorUsedError;
}

ConfigState _$ConfigStateFromJson(Map<String, dynamic> json) {
  return _ConfigState.fromJson(json);
}

/// @nodoc
mixin _$ConfigState {
  Map<String, String> get projectDirectories =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfigStateCopyWith<ConfigState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigStateCopyWith<$Res> {
  factory $ConfigStateCopyWith(
          ConfigState value, $Res Function(ConfigState) then) =
      _$ConfigStateCopyWithImpl<$Res, ConfigState>;
  @useResult
  $Res call({Map<String, String> projectDirectories});
}

/// @nodoc
class _$ConfigStateCopyWithImpl<$Res, $Val extends ConfigState>
    implements $ConfigStateCopyWith<$Res> {
  _$ConfigStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectDirectories = null,
  }) {
    return _then(_value.copyWith(
      projectDirectories: null == projectDirectories
          ? _value.projectDirectories
          : projectDirectories // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ConfigStateCopyWith<$Res>
    implements $ConfigStateCopyWith<$Res> {
  factory _$$_ConfigStateCopyWith(
          _$_ConfigState value, $Res Function(_$_ConfigState) then) =
      __$$_ConfigStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, String> projectDirectories});
}

/// @nodoc
class __$$_ConfigStateCopyWithImpl<$Res>
    extends _$ConfigStateCopyWithImpl<$Res, _$_ConfigState>
    implements _$$_ConfigStateCopyWith<$Res> {
  __$$_ConfigStateCopyWithImpl(
      _$_ConfigState _value, $Res Function(_$_ConfigState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectDirectories = null,
  }) {
    return _then(_$_ConfigState(
      projectDirectories: null == projectDirectories
          ? _value._projectDirectories
          : projectDirectories // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConfigState extends _ConfigState with DiagnosticableTreeMixin {
  const _$_ConfigState(
      {final Map<String, String> projectDirectories = const {'': ''}})
      : _projectDirectories = projectDirectories,
        super._();

  factory _$_ConfigState.fromJson(Map<String, dynamic> json) =>
      _$$_ConfigStateFromJson(json);

  final Map<String, String> _projectDirectories;
  @override
  @JsonKey()
  Map<String, String> get projectDirectories {
    if (_projectDirectories is EqualUnmodifiableMapView)
      return _projectDirectories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_projectDirectories);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ConfigState(projectDirectories: $projectDirectories)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ConfigState'))
      ..add(DiagnosticsProperty('projectDirectories', projectDirectories));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ConfigState &&
            const DeepCollectionEquality()
                .equals(other._projectDirectories, _projectDirectories));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_projectDirectories));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConfigStateCopyWith<_$_ConfigState> get copyWith =>
      __$$_ConfigStateCopyWithImpl<_$_ConfigState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConfigStateToJson(
      this,
    );
  }
}

abstract class _ConfigState extends ConfigState {
  const factory _ConfigState({final Map<String, String> projectDirectories}) =
      _$_ConfigState;
  const _ConfigState._() : super._();

  factory _ConfigState.fromJson(Map<String, dynamic> json) =
      _$_ConfigState.fromJson;

  @override
  Map<String, String> get projectDirectories;
  @override
  @JsonKey(ignore: true)
  _$$_ConfigStateCopyWith<_$_ConfigState> get copyWith =>
      throw _privateConstructorUsedError;
}
