import 'package:aibas/model/data/class.dart';
import 'package:aibas/vm/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompWizard {
  CompWizard({
    required this.wizardText,
    required this.finishText,
    required this.components,
    required this.runNextPage,
    required this.runPreviousPage,
    required this.onFinished,
    required this.onCanceled,
  });

  final String wizardText;
  final String finishText;
  final List<WizardComponents> components;
  final VoidCallback runNextPage;
  final VoidCallback runPreviousPage;
  final VoidCallback onFinished;
  final VoidCallback onCanceled;

  static final isValidContentsProvider = StateProvider<bool>((ref) => false);

  Widget parentWrap({required BuildContext context, required WidgetRef ref}) {
    final pageState = ref.watch(pageProvider);

    // local ref
    final isValidContentsState = ref.watch(isValidContentsProvider);

    final index = pageState.wizardIndex;

    Widget getForwardOrFinishedWidget() {
      if (index < components.length - 1) {
        return SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: isValidContentsState ? runNextPage : null,
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
            onPressed: isValidContentsState ? onFinished : null,
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

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
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
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverAppBar.large(
            title: Text(
              components[index].title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Icon(
                components[index].icon,
                size: 28,
              ),
            ),
            // leadingWidth: 50,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(6),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                tween: Tween<double>(
                  begin: 0,
                  end: (index + 1) / components.length,
                ),
                builder: (context, value, _) =>
                    LinearProgressIndicator(value: value),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  '$wizardText (${index + 1}/${components.length})',
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                width: 60,
                child: IconButton(
                  onPressed: onCanceled,
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(child: components[index].screen),
        ),
      ),
    );
  }
}
