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
