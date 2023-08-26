import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:staplver/vm/log.dart';
import 'package:staplver/vm/page.dart';
import 'package:staplver/vm/svn.dart';

import '../../../model/class/svn.dart';
import '../../../model/constant.dart';
import '../../../model/error/handler.dart';
import '../../routes/projects/details.dart';

class CompPjStatus extends HookConsumerWidget {
  const CompPjStatus({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // notifier
    final pageNotifier = ref.read(pagePod.notifier);
    final svnNotifier = ref.read(svnPod.notifier);

    // local
    final pjStatusState = ref.watch(CompProjectsDetails.pjStatusProvider);
    final selectedEntries = useState(<SvnStatusEntry>[]);

    // local - hooks
    Future<void> revertChanges4SelectedFile() async {
      final entries = selectedEntries.value;
      await pageNotifier.resetProgress();
      var count = 0;

      for (final entry in entries) {
        count++;
        log.t(
          'revertChanges4SelectedFile: ${entry.path} ($count/${entries.length})',
        );
        await svnNotifier.runRevertWorkingFile(entry.path);
        pageNotifier.updateProgress(count / entries.length);
      }
      await CompProjectsDetails.refresh(ref, needUpdate: true);
      await pageNotifier.completeProgress();
      selectedEntries.value = [];
    }

    // view
    Widget content(List<SvnStatusEntry> pjStatus) {
      const title = Padding(
        padding: EdgeInsets.all(8),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          children: [
            Icon(Icons.info_outline, size: 25),
            Text(
              '作業フォルダーの状態',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );

      if (pjStatus.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                title,
                Divider(),
                SizedBox(height: 20),
                Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 48,
                ),
                SizedBox(height: 20),
                Text('変更はありません'),
              ],
            ),
          ),
        );
      }

      Widget topTile() {
        final someSelected = selectedEntries.value.isNotEmpty;
        final allSelected = selectedEntries.value.length == pjStatus.length;
        final isTristate = selectedEntries.value.isNotEmpty &&
            selectedEntries.value.length != pjStatus.length;

        void handleClick({required bool? isSelected}) {
          if (isSelected == null) return;
          if (isSelected) {
            selectedEntries.value = pjStatus;
          } else {
            selectedEntries.value = [];
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Checkbox(
                value: !isTristate ? allSelected : null,
                tristate: isTristate,
                onChanged: (isSelected) => handleClick(isSelected: isSelected),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.restart_alt),
                    tooltip: '変更をもとに戻す',
                    onPressed: someSelected ? revertChanges4SelectedFile : null,
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

          final isSelected = selectedEntries.value.contains(entry);

          void handleClick({required bool? isCheckedVal}) {
            if (isCheckedVal == null) return;
            final copiedSelectedEntry = selectedEntries.value.toList();
            if (isCheckedVal) {
              copiedSelectedEntry.add(entry);
            } else {
              copiedSelectedEntry.remove(entry);
            }
            selectedEntries.value = copiedSelectedEntry;
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
              checkColor: entry.action.color.onColor,
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
      error: (err, trace) => SystemErrorHandler(context, ref).getErrWidget(
        title: '作業フォルダーの状態の読み込みに失敗しました',
        err: err,
        trace: trace,
      ),
      loading: () => const Column(
        children: [
          SizedBox(height: 20),
          Text('作業フォルダーの状態を読み込み中...'),
        ],
      ),
    );
  }
}
