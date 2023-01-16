// ignore_for_file: prefer_void_to_null

import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

extension FileExtension on FileSystemEntity {
  String get name {
    return path.split('\\').last;
  }
}

extension AsyncMap<K, V> on Map<K, V> {
  Future<void> forEachAsync(FutureOr<void> Function(K, V) fun) async {
    for (final value in entries) {
      final k = value.key;
      final v = value.value;
      await fun(k, v);
    }
  }
}

void widgetMounted(VoidCallback init) {
  WidgetsBinding.instance.addPostFrameCallback((_) => init());
}

void widgetMountedAsync(FutureOr<void> Function() init) {
  WidgetsBinding.instance.addPostFrameCallback((_) async => await init());
}

Null onMounted(VoidCallback init) {
  widgetMounted(init);
  return null;
}

Null onMountedAsync(FutureOr<void> Function() init) {
  widgetMountedAsync(init);
  return null;
}
