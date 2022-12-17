import 'dart:io';

import 'package:aibas/view/components/create_pj/set_ignore_files.dart';
import 'package:aibas/view/components/create_pj/set_pj_config.dart';
import 'package:aibas/view/components/create_pj/set_pj_details.dart';
import 'package:aibas/view/components/create_pj/set_working_dir.dart';
import 'package:aibas/vm/page.dart';
import 'package:aibas/vm/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// local ref
final pjNameProvider = StateProvider<String>((ref) => '');
final workingDirProvider = StateProvider<Directory?>((ref) => null);
final backupDirProvider = StateProvider<Directory?>((ref) => null);

class CompCreatePjHelper {
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

    final comps = [
      const CompSetWorkingDir(),
      const CompSetIgnoreFiles(),
      const CompSetPjConfig(),
      const CompSetPjDetails(),
    ];

    void runNextPage() {
      pageNotifier.updateCreatePjIndex(index + 1);
    }

    void runPreviousPage() {
      pageNotifier.updateCreatePjIndex(index - 1);
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
            onPressed: isValidContents ? () {} : null,
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

    final comps = [
      const CompSetWorkingDir(),
      const CompSetIgnoreFiles(),
      const CompSetPjConfig(),
      const CompSetPjDetails(),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 60,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
        leading: const SizedBox(),
        title: Text(
          '新規プロジェクトの作成 (${index + 1}/${comps.length})',
          style: myTextStyle(fontWeight: FontWeight.w600),
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