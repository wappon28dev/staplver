import 'package:aibas/model/helper/svn.dart';
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
    final cmdSVNState = ref.watch(cmdSVNProvider);
    final cmdSVNNotifier = ref.read(cmdSVNProvider.notifier);

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
      context,
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
          Text('log =>\n ${cmdSVNState.stdout}'),
          ElevatedButton(
            onPressed: cmdSVNNotifier.runCreate,
            child: const Text('svn create'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: cmdSVNNotifier.runImport,
            child: const Text('svn import'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: cmdSVNNotifier.runRename,
            child: const Text('run rename'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: cmdSVNNotifier.runCheckout,
            child: const Text('svn checkout'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: cmdSVNNotifier.runStaging,
            child: const Text('svn add .'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: cmdSVNNotifier.update,
            child: const Text('svn update'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: TextField(
              onSubmitted: cmdSVNNotifier.runCommit,
              decoration: const InputDecoration(
                labelText: 'Input',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
