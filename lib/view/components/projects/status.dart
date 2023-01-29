import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/class/svn.dart';
import '../../../model/constant.dart';
import '../../../model/error/handler.dart';
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
        final colorScheme = Theme.of(context).colorScheme;

        for (final entry in pjStatus) {
          final textColor =
              entry.item.color.harmonizeWith(colorScheme.background);

          tiles.add(
            CheckboxListTile(
              title: Text(
                File(entry.path).name,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(entry.path),
              secondary: entry.item.chips(colorScheme),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              value: true,
              onChanged: (_) {},
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
      error: (err, trace) => AIBASErrHandler(context, ref).getErrWidget(
        title: '作業フォルダーの状態の読み込みに失敗しました',
        err: err,
        trace: trace,
      ),
      loading: () => Column(
        children: const [
          SizedBox(height: 20),
          Text('作業フォルダーの状態を読み込み中...'),
        ],
      ),
    );
  }
}
