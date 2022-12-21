import 'package:aibas/view/routes/fab/checkout.dart';
import 'package:aibas/view/routes/fab/create_pj.dart';
import 'package:aibas/view/routes/fab/import_pj.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteController {
  RouteController(this.ref);
  WidgetRef ref;

  static void runPush({
    required BuildContext context,
    required Widget page,
    bool isReplace = false,
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

  void home2createPj() {
    final pageNotifier = ref.read(pageProvider.notifier);
    final contentsState = ref.watch(contentsProvider);
    final contentsNotifier = ref.read(contentsProvider.notifier);

    // local
    final pjNameNotifier = ref.read(CompCreatePjHelper.pjNameProvider.notifier);
    final workingDirNotifier =
        ref.read(CompCreatePjHelper.workingDirProvider.notifier);
    final backupDirNotifier =
        ref.read(CompCreatePjHelper.backupDirProvider.notifier);

    debugPrint('-- init (home -> createPj) --');
    pageNotifier.updateWizardIndex(0);
    pjNameNotifier.state = '';
    workingDirNotifier.state = null;
    backupDirNotifier.state = contentsState.defaultBackupDir;
    contentsNotifier.updateDragAndDropSendTo(workingDirNotifier);
    debugPrint('-- end --');
  }

  void home2importPj() {
    final pageNotifier = ref.read(pageProvider.notifier);
    final contentsNotifier = ref.read(contentsProvider.notifier);

    // local
    final workingDirNotifier =
        ref.read(CompImportPjHelper.workingDirProvider.notifier);
    final importedPjNotifier =
        ref.read(CompImportPjHelper.importedPjProvider.notifier);

    debugPrint('-- init (home -> importPj) --');
    pageNotifier.updateWizardIndex(0);
    workingDirNotifier.state = null;
    importedPjNotifier.state = null;
    contentsNotifier.updateDragAndDropSendTo(workingDirNotifier);
    debugPrint('-- end --');
  }

  void home2checkout() {
    final pageNotifier = ref.read(pageProvider.notifier);
    final contentsNotifier = ref.read(contentsProvider.notifier);

    // local
    final workingDirNotifier =
        ref.read(CompCheckoutHelper.workingDirProvider.notifier);
    final newPjDataNotifier =
        ref.read(CompCheckoutHelper.newPjDataProvider.notifier);

    debugPrint('-- init (home -> createPj) --');
    pageNotifier.updateWizardIndex(0);
    workingDirNotifier.state = null;
    newPjDataNotifier.state = null;
    contentsNotifier.updateDragAndDropSendTo(workingDirNotifier);
    debugPrint('-- end --');
  }
}
