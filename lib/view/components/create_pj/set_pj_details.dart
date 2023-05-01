import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../wizard.dart';

class CompSetPjDetails extends ConsumerWidget {
  const CompSetPjDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(CompWizard.isValidContentsPod.notifier).state = true,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: Theme.of(context).colorScheme.errorContainer,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Icon(
                  Icons.warning,
                  size: 100,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 10),
                const Text('まだ動作が不安定です.  適当なフォルダーで試すことを強くおすすめします.'),
                Text(
                  'リポジトリを作成します.  本当によろしいですか？',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
