import 'package:aibas/model/constant.dart';
import 'package:aibas/view/routes/fab/create_pj.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompSetIgnoreFiles extends HookConsumerWidget {
  const CompSetIgnoreFiles({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workingDirState = ref.watch(PageCreatePj.workingDirProvider);
    final ignoreFilesState = ref.watch(PageCreatePj.ignoreFilesProvider);
    final ignoreFilesNotifier =
        ref.read(PageCreatePj.ignoreFilesProvider.notifier);
    final dirList = useMemoized(
      () => workingDirState?.list(recursive: true).toList(),
    );
    final dirListSnapshot = useFuture(dirList);

    if (workingDirState == null) throw Exception('workingDirState is null!');

    // ignore: avoid_positional_boolean_parameters
    void handleCheckBoxClicked(int index, bool? newVal) {
      if (newVal == null || dirList == null) return;
      if (!dirListSnapshot.hasData) return;

      final copiedList = ignoreFilesState.toList();
      if (newVal) {
        copiedList.add(dirListSnapshot.data![index]);
      } else {
        copiedList.remove(dirListSnapshot.data![index]);
      }
      ignoreFilesNotifier.state = copiedList;
    }

    List<Widget> tiles() {
      final tiles = <Widget>[];
      final length = dirListSnapshot.data?.length ?? 0;
      final colorScheme = Theme.of(context).colorScheme;

      final selectedTileColor = colorScheme.primaryContainer;
      final checkColor = colorScheme.onPrimary;
      final activeColor = colorScheme.primary;

      for (var index = 0; index < length; index++) {
        tiles.add(
          CheckboxListTile(
            value: ignoreFilesState.contains(dirListSnapshot.data![index]),
            onChanged: (newVal) => handleCheckBoxClicked(index, newVal),
            title: Text(dirListSnapshot.data![index].name),
            subtitle: Text(dirListSnapshot.data![index].path),
            selected: ignoreFilesState.contains(dirListSnapshot.data![index]),
            selectedTileColor: selectedTileColor,
            checkColor: checkColor,
            activeColor: activeColor,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
      }
      return tiles;
    }

    if (dirListSnapshot.hasData) {
      return Column(children: tiles());
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('フォルダーの中身を探索中...'),
          ],
        ),
      );
    }
  }
}
