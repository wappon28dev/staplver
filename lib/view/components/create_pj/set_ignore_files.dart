import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/constant.dart';
import '../../routes/fab/create_pj.dart';
import '../wizard.dart';

class CompSetIgnoreFiles extends HookConsumerWidget {
  const CompSetIgnoreFiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // local - state
    final workingDirState = ref.watch(PageCreatePj.workingDirProvider);
    final ignoreFilesState = ref.watch(PageCreatePj.ignoreFilesProvider);

    // assert
    if (workingDirState == null) throw Exception('workingDirState is null!');

    // local - notifier
    final isValidContentsNotifier =
        ref.read(CompWizard.isValidContentsPod.notifier);
    final ignoreFilesNotifier =
        ref.read(PageCreatePj.ignoreFilesProvider.notifier);

    // local - hooks
    final searchText = useState('');
    final dirList = useMemoized(
      () => workingDirState.list(recursive: true).toList(),
    );
    final dirListSnapshot = useFuture(dirList);

    // init
    useEffect(() => onMounted(() => isValidContentsNotifier.state = true), []);

    // ignore: avoid_positional_boolean_parameters
    void handleCheckBoxClicked(FileSystemEntity newFile, bool? newVal) {
      if (newVal == null) return;
      if (!dirListSnapshot.hasData) return;

      final copiedList = ignoreFilesState.toList();
      if (newVal) {
        copiedList.add(newFile);
      } else {
        copiedList.remove(newFile);
      }
      ignoreFilesNotifier.state = copiedList;
    }

    List<Widget> tiles() {
      final tiles = <Widget>[];
      final colorScheme = Theme.of(context).colorScheme;

      final selectedTileColor = colorScheme.primaryContainer;
      final checkColor = colorScheme.onPrimary;
      final activeColor = colorScheme.primary;

      final filteredDirList = dirListSnapshot.data
          ?.where(
            (element) => element.path.contains(searchText.value),
          )
          .toList();

      for (final dirData in filteredDirList ?? <FileSystemEntity>[]) {
        tiles.add(
          CheckboxListTile(
            value: ignoreFilesState.contains(dirData),
            onChanged: (newVal) => handleCheckBoxClicked(dirData, newVal),
            title: Text(dirData.name),
            subtitle: Text(dirData.path),
            selected: ignoreFilesState.contains(dirData),
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
      return Column(
        children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  autofocus: true,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'ここにファイル名を入力して検索',
                    errorStyle:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (newVal) {
                    searchText.value = newVal;
                  },
                ),
              ),
              Wrap(
                spacing: 30,
                children: [
                  ActionChip(
                    label: const Text('全て選択する'),
                    avatar: const Icon(Icons.select_all),
                    onPressed: () {
                      if (dirListSnapshot.hasData) {
                        final filteredDirList = dirListSnapshot.data!
                            .where(
                              (element) =>
                                  element.path.contains(searchText.value),
                            )
                            .toList();
                        ignoreFilesNotifier.state = filteredDirList;
                      }
                    },
                  ),
                  ActionChip(
                    label: const Text('全て選択解除する'),
                    avatar: const Icon(Icons.deselect),
                    iconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onPressed: () => ignoreFilesNotifier.state = [],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ] +
            tiles(),
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('フォルダーの中身を探索中...'),
          ],
        ),
      );
    }
  }
}
