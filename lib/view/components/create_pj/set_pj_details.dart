import 'package:aibas/view/routes/fab/create_pj.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompSetPjDetails extends ConsumerWidget {
  CompSetPjDetails({super.key});
  final elapsedProvider = StateProvider<int>((ref) => 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const delaySec = 5;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ref.read(elapsedProvider) >= delaySec) return;
      await Future<void>.delayed(const Duration(seconds: 1))
          .then((value) => ref.read(elapsedProvider.notifier).state++);
    });

    return CompCreatePjHelper().wrap(
      context: context,
      ref: ref,
      isValidContents: ref.watch(elapsedProvider) == 5,
      mainContents: Column(
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
          ref.watch(elapsedProvider) < delaySec
              ? Text((delaySec - ref.watch(elapsedProvider)).toString())
              : const Text('')
        ],
      ),
    );
  }
}
