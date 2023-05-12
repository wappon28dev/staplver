import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/class/app.dart';
import '../../vm/page.dart';

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

  static final isValidContentsPod = StateProvider<bool>((ref) => false);

  Widget parentWrap({required BuildContext context, required WidgetRef ref}) {
    final pageState = ref.watch(pagePod);

    // local ref
    final isValidContentsState = ref.watch(isValidContentsPod);

    final index = pageState.wizardIndex;

    Widget getForwardOrFinishedWidget() {
      if (index < components.length - 1) {
        return SizedBox(
          height: 40,
          child: FilledButton.tonal(
            onPressed: isValidContentsState ? runNextPage : null,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('次へ'),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        );
      } else {
        return SizedBox(
          height: 40,
          child: FilledButton(
            onPressed: isValidContentsState ? onFinished : null,
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
