import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'now.g.dart';

@riverpod
Stream<DateTime> now(NowRef ref) async* {
  while (true) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    yield DateTime.now();
  }
}
