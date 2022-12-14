import 'package:aibas/model/state.dart';
import 'package:aibas/view/components/navbar.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageDebug extends ConsumerWidget {
  const PageDebug({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final navbar = NavBar(ref: ref, orientation: orientation);

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

    return navbar.getRailsNavbar(
      Column(
        children: <Widget>[
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
    );
  }
}
