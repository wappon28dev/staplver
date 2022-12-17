// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConfigState _$$_ConfigStateFromJson(Map<String, dynamic> json) =>
    _$_ConfigState(
      projectDirectories:
          (json['projectDirectories'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              const {'': ''},
    );

Map<String, dynamic> _$$_ConfigStateToJson(_$_ConfigState instance) =>
    <String, dynamic>{
      'projectDirectories': instance.projectDirectories,
    };
