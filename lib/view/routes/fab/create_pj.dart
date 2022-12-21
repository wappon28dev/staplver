import 'dart:io';

import 'package:aibas/model/data/class.dart';
import 'package:aibas/view/components/create_pj/set_ignore_files.dart';
import 'package:aibas/view/components/create_pj/set_pj_config.dart';
import 'package:aibas/view/components/create_pj/set_pj_details.dart';
import 'package:aibas/view/components/create_pj/set_working_dir.dart';
import 'package:aibas/view/components/wizard.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/page.dart';
import 'package:aibas/vm/projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompCreatePjHelper {
  static final pjNameProvider = StateProvider<String>((ref) => '');
  static final workingDirProvider = StateProvider<Directory?>((ref) => null);
  static final backupDirProvider = StateProvider<Directory?>((ref) => null);

  static final components = [
    const CompSetWorkingDir(),
    const CompSetIgnoreFiles(),
    const CompSetPjConfig(),
    CompSetPjDetails(),
  ];

  void runInit(WidgetRef ref, int compIndex) {
    final contentsNotifier = ref.read(contentsProvider.notifier);
    final workingDirNotifier = ref.read(workingDirProvider.notifier);
    final backupDirNotifier = ref.read(backupDirProvider.notifier);

    final init = [
      () => contentsNotifier.updateDragAndDropSendTo(workingDirNotifier),
      () => contentsNotifier.updateDragAndDropSendTo(null),
      () => contentsNotifier.updateDragAndDropSendTo(backupDirNotifier),
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

  Future<void> runCreateProject(WidgetRef ref) async {
    final projectsNotifier = ref.watch(projectsProvider.notifier);

    final pjNameState = ref.watch(pjNameProvider);
    final workingDirState = ref.watch(workingDirProvider);
    final backupDirState = ref.watch(backupDirProvider);

    if (workingDirState == null || backupDirState == null) {
      throw Exception('newProject contains null!');
    }

    final newProject = Project(
      name: pjNameState,
      workingDir: workingDirState,
      backupDir: backupDirState,
      backupMin: 20,
    );

    projectsNotifier
      ..updateSavedProject([newProject])
      ..updateCurrentPjIndex(0);
    await projectsNotifier.initProject();
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
      onFinished: () async {
        await runCreateProject(ref);
        // ignore: use_build_context_synchronously
        runDispose(context, ref);
      },
    ).wrap(
      context: context,
      ref: ref,
      isValidContents: isValidContents,
      mainContents: mainContents,
    );
  }
}

class PageCreatePj extends ConsumerWidget {
  const PageCreatePj({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageState = ref.watch(pageProvider);
    final index = pageState.wizardIndex;
    final comps = CompCreatePjHelper.components;

    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 60,
            child: IconButton(
              onPressed: () => CompCreatePjHelper().runDispose(context, ref),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
        leading: const SizedBox(),
        title: Text(
          '新規プロジェクトの作成 (${index + 1}/${comps.length})',
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
