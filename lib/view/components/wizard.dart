import 'package:aibas/vm/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompWizard {
  CompWizard({
    required this.finishText,
    required this.runNextPage,
    required this.runPreviousPage,
    required this.components,
    required this.onFinished,
  });

  final String finishText;
  final VoidCallback runNextPage;
  final VoidCallback runPreviousPage;
  final List<Widget> components;
  final VoidCallback onFinished;

  Widget wrap({
    required BuildContext context,
    required WidgetRef ref,
    required bool isValidContents,
    required Widget mainContents,
  }) {
    final pageState = ref.watch(pageProvider);
    final index = pageState.wizardIndex;

    Widget getForwardOrFinishedWidget() {
      if (index < components.length - 1) {
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
            onPressed: isValidContents ? onFinished : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(finishText),
                const Icon(Icons.add),
              ],
            ),
          ),
        );
      }
    }

    return Column(
      children: [
        Expanded(child: mainContents),
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
