import 'dart:ui';

import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/projects.dart';
import 'package:aibas/vm/svn.dart';
import 'package:aibas/vm/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageDebug extends ConsumerWidget {
  const PageDebug({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final contentsState = ref.watch(contentsProvider);
    final cmdSVNState = ref.watch(cmdSVNProvider);
    final cmdSVNNotifier = ref.read(cmdSVNProvider.notifier);
    final projectsState = ref.watch(projectsProvider);

    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: cmdSVNNotifier.runStatus,
              child: const Text('svn status'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: cmdSVNNotifier.runInfo,
              child: const Text('svn info'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: cmdSVNNotifier.runLog,
              child: const Text('svn log'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: cmdSVNNotifier.runCreate,
              child: const Text('svn create'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: cmdSVNNotifier.runImport,
              child: const Text('svn import'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: cmdSVNNotifier.runRename,
              child: const Text('run rename'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: cmdSVNNotifier.runCheckout,
              child: const Text('svn checkout'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: cmdSVNNotifier.runStaging,
              child: const Text('svn add .'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: cmdSVNNotifier.update,
              child: const Text('svn update'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          child: TextField(
            onSubmitted: cmdSVNNotifier.runCommit,
            decoration: const InputDecoration(
              labelText: 'commit message',
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('''
  savedProjects:
    ${projectsState.savedProjects.toString()}
  currentPjIndex:
    ${projectsState.currentPjIndex.toString()}
  currentPj:
    ${projectsState.currentPj.toString()}
  defaultWorkingDir:
    ${contentsState.defaultBackupDir?.path}
  
'''),
        Text(
          'log:\n ${cmdSVNState.stdout}',
          style: const TextStyle(
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
