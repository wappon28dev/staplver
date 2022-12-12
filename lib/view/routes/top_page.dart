import 'package:aibas/model/state.dart';
import 'package:aibas/view/components/bottom_navigation_bar.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopPage extends ConsumerWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final contentsState = ref.watch(contentsProvider);
    final contentsNotifier = ref.watch(contentsProvider.notifier);

    List<DropdownMenuItem<DirectoryKinds>> dropdownList() {
      final dropdown = <DropdownMenuItem<DirectoryKinds>>[];
      for (final element in DirectoryKinds.values) {
        dropdown.add(
          DropdownMenuItem<DirectoryKinds>(
            value: element,
            child: Text(element.name),
          ),
        );
      }
      return dropdown;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter MVVM')),
      bottomNavigationBar: bottomNavigationBar,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'working => ${contentsState.workingDirectory?.path ?? 'null'}',
            ),
            Text(
              'backup => ${contentsState.backupDirectory?.path ?? 'null'}',
            ),
            DropdownButton<DirectoryKinds>(
              value: contentsState.directoryKinds,
              items: dropdownList(),
              onChanged: (DirectoryKinds? newVal) {
                if (newVal != null) {
                  contentsNotifier.updateDirectoryKinds(newVal);
                }
              },
            ),
            Text(themeState.themeMode.name),
          ],
        ),
      ),
    );
  }
}
