import 'dart:async';
import 'dart:io';

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

enum BaseCommand {
  svn,
  svnadmin,
  mkdir,
}
