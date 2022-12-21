import 'dart:io';

import 'package:aibas/model/data/class.dart';
import 'package:aibas/view/components/checkout/pj_summary.dart';
import 'package:aibas/view/components/checkout/set_backup_dir.dart';
import 'package:aibas/view/components/checkout/set_working_dir.dart';
import 'package:aibas/view/components/wizard.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompCheckoutHelper {
  static final workingDirProvider = StateProvider<Directory?>((ref) => null);
  static final backupDirProvider = StateProvider<Directory?>((ref) => null);
  static final newPjDataProvider = StateProvider<Project?>((ref) => null);

  static const components = [
    CompSetBackupDir(),
    CompSetWorkingDir(),
    CompPjSummary(),
  ];

  void runInit(WidgetRef ref, int compIndex) {
    final contentsNotifier = ref.read(contentsProvider.notifier);
    final workingDirNotifier = ref.read(workingDirProvider.notifier);
    final backupDirNotifier = ref.read(backupDirProvider.notifier);

    final init = [
      () => contentsNotifier.updateDragAndDropSendTo(backupDirNotifier),
      () => contentsNotifier.updateDragAndDropSendTo(workingDirNotifier),
      () => contentsNotifier.updateDragAndDropSendTo(null),
    ];

    init[compIndex]();
  }

  void runNextPage(WidgetRef ref) {
    final pageState = ref.watch(pageProvider);
    final pageNotifier = ref.read(pageProvider.notifier);
    final index = pageState.wizardIndex;

    pageNotifier.updateWizardIndex(index + 1);
    runInit(ref, index + 1);
  }

  void runPreviousPage(WidgetRef ref) {
    final pageState = ref.watch(pageProvider);
    final pageNotifier = ref.read(pageProvider.notifier);
    final index = pageState.wizardIndex;

    pageNotifier.updateWizardIndex(index - 1);
    runInit(ref, index - 1);
  }

  void runDispose(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);
    ref.read(contentsProvider.notifier).updateDragAndDropSendTo(null);
  }

  Widget wrap({
    required BuildContext context,
    required WidgetRef ref,
    // ignore: avoid_positional_boolean_parameters
    required bool isValidContents,
    required Widget mainContents,
  }) {
    return CompWizard(
      finishText: '作成',
      runNextPage: () => runNextPage(ref),
      runPreviousPage: () => runPreviousPage(ref),
      components: components,
      onFinished: () => runDispose(context, ref),
    ).wrap(
      context: context,
      ref: ref,
      isValidContents: isValidContents,
      mainContents: mainContents,
    );
  }
}

class PageCheckout extends ConsumerWidget {
  const PageCheckout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageState = ref.watch(pageProvider);
    final index = pageState.wizardIndex;
    const comps = CompCheckoutHelper.components;

    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 60,
            child: IconButton(
              onPressed: () => CompCheckoutHelper().runDispose(context, ref),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
        leading: const SizedBox(),
        title: Text(
          'バックアップフォルダーから作業コピーをとる (${index + 1}/${comps.length})',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            tween: Tween<double>(
              begin: 0,
              end: (index + 1) / comps.length,
            ),
            builder: (context, value, _) =>
                LinearProgressIndicator(value: value),
          ),
        ),
      ),
      body: comps[index],
    );
  }
}