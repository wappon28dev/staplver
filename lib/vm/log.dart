// ignore_for_file: constant_identifier_names

import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:staplver/model/state.dart';

part 'log.g.dart';

final log = Logger(
  printer: PrettyPrinter(
    lineLength: 200,
    errorMethodCount: 10,
    printTime: true,
  ),
);

const START = '┏ Start';
const FINISH = '┗ Finish';

extension LoggerExtension on Logger {
  void ds(String message) => d('$START $message ...');
  void df(String message) => d('$FINISH $message');
}

@riverpod
class Log extends _$Log {
  @override
  LogState build() {
    return const LogState();
  }

  void add(String newLog) {
    state = state.copyWith(logs: [...state.logs, newLog]);
  }
}
