import 'dart:io';

import 'package:aibas/model/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final configProvider = StateNotifierProvider<ConfigNotifier, ConfigState>(
  (ref) => ConfigNotifier(),
);

class ConfigNotifier extends StateNotifier<ConfigState> {
  ConfigNotifier() : super(const ConfigState());

  void updateDirectories(Map<Directory, Directory> newProjectDirectories) {
    debugPrint('newProjectDirectories => $newProjectDirectories');

    final strPrjDir = newProjectDirectories.cast<String, String>();

    state = state.copyWith(projectDirectories: strPrjDir);
  }

  void exportConfig() {
    debugPrint(state.toJson().toString());
  }
}
