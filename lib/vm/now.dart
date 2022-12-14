import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowProvider = StreamProvider.autoDispose<DateTime>((ref) async* {
  while (true) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    yield DateTime.now();
  }
});
