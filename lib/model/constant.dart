// ignore_for_file: prefer_void_to_null

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

extension FileExtension on FileSystemEntity {
  String get name {
    return basename(path);
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

extension OnPrimary on Color {
  Color get onColor {
    if (computeLuminance() < 0.5) {
      return Colors.white;
    }
    return Colors.black;
  }
}

VoidCallback? onMounted(
  VoidCallback init, [
  VoidCallback? dispose,
]) {
  WidgetsBinding.instance.addPostFrameCallback((_) => init());
  return dispose;
}

VoidCallback? onMountedAsync(
  FutureOr<void> Function() init, [
  VoidCallback? dispose,
]) {
  WidgetsBinding.instance.addPostFrameCallback((_) async => await init());
  return dispose;
}

final gitHubReleaseUrl = Uri.https(
  'github.com',
  'wappon-28-dev/staplver/releases',
);
