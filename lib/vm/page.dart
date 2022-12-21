import 'package:aibas/model/state.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageProvider = StateNotifierProvider<PageNotifier, PageState>(
  (ref) => PageNotifier(),
);

class PageNotifier extends StateNotifier<PageState> {
  PageNotifier() : super(const PageState());

  void updateNavbarIndex(int newNavbarIndex) {
    debugPrint('newNavbarIndex => $newNavbarIndex');
    state = state.copyWith(navbarIndex: newNavbarIndex);
  }

  // ignore: avoid_positional_boolean_parameters
  void updateAskWhenClose(bool newAskWhenQuit) {
    debugPrint('newAskWhenQuit => $newAskWhenQuit');
    state = state.copyWith(askWhenQuit: newAskWhenQuit);
  }

  void updateCreatePjIndex(int newCreatePjIndex) {
    debugPrint('newCreatePjIndex => $newCreatePjIndex');
    state = state.copyWith(createPjIndex: newCreatePjIndex);
  }
}
