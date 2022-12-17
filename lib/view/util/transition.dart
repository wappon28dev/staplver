import 'package:aibas/view/routes/create_pj.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteController {
  RouteController(this.context, this.ref);
  BuildContext context;
  WidgetRef ref;

  static void runPush({
    required BuildContext context,
    required Widget page,
    required bool isReplace,
  }) {
    if (!isReplace) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => page,
        ),
      );
    } else {
      Navigator.pushAndRemoveUntil<void>(
        context,
        MaterialPageRoute<void>(builder: (context) => page),
        (_) => false,
      );
    }
  }

  void home2fab() {
    final pageNotifier = ref.read(pageProvider.notifier);
    final pjNameNotifier = ref.read(pjNameProvider.notifier);
    final workingDirNotifier = ref.read(workingDirProvider.notifier);
    final backupDirNotifier = ref.read(backupDirProvider.notifier);

    debugPrint('-- init (home -> fab) --');
    pageNotifier.updateCreatePjIndex(0);
    pjNameNotifier.state = '';
    workingDirNotifier.state = null;
    backupDirNotifier.state = null;
    debugPrint('-- end --');
  }
}
