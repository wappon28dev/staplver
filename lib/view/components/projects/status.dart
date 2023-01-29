import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final selectedEntry = useState(<SvnStatusEntry>[]);

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

      Widget topTile() {
        final someSelected = selectedEntry.value.isNotEmpty;
        final allSelected = selectedEntry.value.length == pjStatus.length;
        void handleClick({required bool? isSelected}) {
          if (isSelected == null) return;
          if (isSelected) {
            selectedEntry.value = pjStatus;
          } else {
            selectedEntry.value = [];
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Checkbox(
                value: allSelected,
                tristate: selectedEntry.value.isNotEmpty &&
                    selectedEntry.value.length != pjStatus.length,
                onChanged: (isSelected) => handleClick(isSelected: isSelected),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.restart_alt),
                    tooltip: '変更の破棄',
                    onPressed: someSelected ? () {} : null,
                  )
                ],
              ),
            ),
          ],
        );
      }

      List<Widget> getTiles() {
        final tiles = <Widget>[];
        final colorScheme = Theme.of(context).colorScheme;

        for (final entry in pjStatus) {
          final textColor =
              entry.action.color.harmonizeWith(colorScheme.background);

          final isSelected = selectedEntry.value.contains(entry);

          void handleClick({required bool? isCheckedVal}) {
            if (isCheckedVal == null) return;
            final copiedSelectedEntry = selectedEntry.value.toList();
            if (isCheckedVal) {
              copiedSelectedEntry.add(entry);
            } else {
              copiedSelectedEntry.remove(entry);
            }
            selectedEntry.value = copiedSelectedEntry;
          }

          tiles.add(
            CheckboxListTile(
              title: Text(
                File(entry.path).name,
                style: TextStyle(
                  color: textColor.harmonizeWith(colorScheme.background),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(entry.path),
              secondary: entry.action.chips(colorScheme),
              controlAffinity: ListTileControlAffinity.leading,
              value: isSelected,
              dense: true,
              activeColor: entry.action.color.shade400,
              tileColor:
                  isSelected ? entry.action.color.withOpacity(0.1) : null,
              onChanged: (isCheckVal) => handleClick(isCheckedVal: isCheckVal),
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
                topTile(),
                const Divider(),
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
