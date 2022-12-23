import 'dart:io';

extension FileExtension on FileSystemEntity {
  String get name {
    return path.split('\\').last;
  }
}
