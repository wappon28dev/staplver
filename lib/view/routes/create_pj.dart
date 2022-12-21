import 'dart:developer';
import 'dart:io';

import 'package:aibas/model/data/class.dart';
import 'package:aibas/model/state.dart';
import 'package:aibas/view/components/create_pj/set_ignore_files.dart';
import 'package:aibas/view/components/create_pj/set_pj_config.dart';
import 'package:aibas/view/components/create_pj/set_pj_details.dart';
import 'package:aibas/view/components/create_pj/set_working_dir.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/page.dart';
import 'package:aibas/vm/projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// local ref
final pjNameProvider = StateProvider<String>((ref) => '');
final workingDirProvider = StateProvider<Directory?>((ref) => null);
final backupDirProvider = StateProvider<Directory?>((ref) => null);

class CompCreatePjHelper {
  final comps = [
    const CompSetWorkingDir(),
    const CompSetIgnoreFiles(),
    const CompSetPjConfig(),
    CompSetPjDetails(),
  ];

  void runInit(WidgetRef ref, int compIndex) {
    final contentsNotifier = ref.read(contentsProvider.notifier);

    final init = [
      () => contentsNotifier.updateDragAndDropSendTo(DirectoryKinds.working),
      () => contentsNotifier.updateDragAndDropSendTo(DirectoryKinds.none),
      () => contentsNotifier.updateDragAndDropSendTo(DirectoryKinds.backup),
      () => contentsNotifier.updateDragAndDropSendTo(DirectoryKinds.none),
    ];

    init[compIndex]();
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

    ref
        .read(contentsProvider.notifier)
        .updateDragAndDropSendTo(DirectoryKinds.none);
  }

  Widget wrap(
    BuildContext context,
    WidgetRef ref,
    // ignore: avoid_positional_boolean_parameters
    bool isValidContents,
    Widget mainContent,
  ) {
    final pageState = ref.watch(pageProvider);
    final pageNotifier = ref.read(pageProvider.notifier);

    final index = pageState.createPjIndex;

    void runNextPage() {
      pageNotifier.updateCreatePjIndex(index + 1);
      runInit(ref, index + 1);
    }

    void runPreviousPage() {
      pageNotifier.updateCreatePjIndex(index - 1);
      runInit(ref, index - 1);
    }

    Widget getForwardOrFinishedWidget() {
      if (index < comps.length - 1) {
        return SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: isValidContents ? runNextPage : null,
            style: ElevatedButton.styleFrom(
              foregroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('次へ'),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        );
      } else {
        return SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: isValidContents
                ? () async {
                    await runCreateProject(ref);
                    // ignore: use_build_context_synchronously
                    runDispose(context, ref);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('作成'),
                Icon(Icons.add),
              ],
            ),
          ),
        );
      }
    }

    return Column(
      children: [
        Expanded(child: mainContent),
        Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 40,
                  child: TextButton.icon(
                    label: const Text('戻る'),
                    icon: const Icon(Icons.arrow_back),
                    onPressed: index == 0 ? null : runPreviousPage,
                  ),
                ),
                getForwardOrFinishedWidget(),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class PageCreatePj extends ConsumerWidget {
  const PageCreatePj({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageState = ref.watch(pageProvider);

    final index = pageState.createPjIndex;

    final comps = CompCreatePjHelper().comps;

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
