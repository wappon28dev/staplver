import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/class/svn.dart';
import '../../routes/projects/details.dart';

class CompPjStatus extends HookConsumerWidget {
  const CompPjStatus({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // local
    final pjStatusState = ref.watch(CompProjectsDetails.pjStatusProvider);

    // view
    Widget content(List<SvnStatusEntry> pjStatus) {
      final title = Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          children: [
            const Icon(Icons.info_outline, size: 28),
            Text(
              '作業フォルダーの状態',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      );

      if (pjStatus.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                title,
                const Divider(),
                const SizedBox(height: 20),
                const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 20),
                const Text('変更はありません'),
              ],
            ),
          ),
        );
      }

      List<Widget> getTiles() {
        final tiles = <Widget>[];

        for (final entry in pjStatus) {
          tiles.add(
            ListTile(
              leading: Icon(
                entry.item == SvnActions.added
                    ? Icons.add
                    : entry.item == SvnActions.deleted
                        ? Icons.delete
                        : Icons.edit,
                color: entry.item == SvnActions.added
                    ? Colors.green
                    : entry.item == SvnActions.deleted
                        ? Colors.red
                        : Colors.blue,
              ),
              title: Text(entry.path),
            ),
          );
        }
        return tiles;
      }

      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
                title,
                const Divider(),
                const SizedBox(height: 20),
              ] +
              getTiles(),
        ),
      );
    }

    return pjStatusState.when(
      data: content,
      error: (err, _) => Center(
        child: Text(
          'セーブポイントの読み込みに失敗しました\n'
          '$err',
        ),
      ),
      loading: () => const Center(
        child: Text('セーブポイントを読み込み中...'),
      ),
    );
  }
}
