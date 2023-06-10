import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:staplver/model/state.dart';

part 'log.g.dart';

final log = Logger(printer: PrettyPrinter());

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
