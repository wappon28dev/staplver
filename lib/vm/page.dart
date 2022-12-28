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

  void updateProgress(double newProgress) {
    // debugPrint('newProgress => $newProgress');
    state = state.copyWith(progress: newProgress);
  }

  // ignore: avoid_positional_boolean_parameters
  void updateIsVisibleProgressBar(bool newIsVisibleProgressBar) {
    debugPrint('newIsVisibleProgressBar => $newIsVisibleProgressBar');
    state = state.copyWith(isVisibleProgressBar: newIsVisibleProgressBar);
  }

  Future<void> resetProgress() async {
    updateIsVisibleProgressBar(false);
    updateProgress(0);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    updateIsVisibleProgressBar(true);
  }

  Future<void> completeProgress() async {
    updateProgress(1);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    updateIsVisibleProgressBar(false);
  }

  // ignore: avoid_positional_boolean_parameters
  void updateAskWhenClose(bool newAskWhenQuit) {
    debugPrint('newAskWhenQuit => $newAskWhenQuit');
    state = state.copyWith(askWhenQuit: newAskWhenQuit);
  }

  void updateWizardIndex(int newWizardIndex) {
    debugPrint('newWizardIndex => $newWizardIndex');
    state = state.copyWith(wizardIndex: newWizardIndex);
  }
}
