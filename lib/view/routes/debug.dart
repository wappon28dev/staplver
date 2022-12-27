import 'dart:ui';

import 'package:aibas/repository/config.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/page.dart';
import 'package:aibas/vm/projects.dart';
import 'package:aibas/vm/svn.dart';
import 'package:aibas/vm/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageDebug extends ConsumerWidget {
  const PageDebug({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsState = ref.watch(contentsProvider);
    final cmdSVNState = ref.watch(cmdSVNProvider);
    final cmdSVNNotifier = ref.read(cmdSVNProvider.notifier);
    final projectsState = ref.watch(projectsProvider);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Wrap(
            spacing: 40,
            runSpacing: 20,
            children: [
              ElevatedButton(
                onPressed: cmdSVNNotifier.runStatus,
                child: const Text('svn status'),
              ),
              ElevatedButton(
                onPressed: cmdSVNNotifier.runInfo,
                child: const Text('svn info'),
              ),
              ElevatedButton(
                onPressed: cmdSVNNotifier.runLog,
                child: const Text('svn log'),
              ),
              ElevatedButton(
                onPressed: cmdSVNNotifier.runCreate,
                child: const Text('svn create'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pageNotifier = ref.read(pageProvider.notifier)
                    ..updateProgress(0)
                    ..updateIsVisibleProgressBar(true);

                  for (var i = 0; i <= 5; i++) {
                    pageNotifier.updateProgress(0.2 * i);
                    await Future<void>.delayed(
                        const Duration(milliseconds: 300));
                  }
                  await Future<void>.delayed(const Duration(milliseconds: 600));
                  // pageNotifier.updateProgress(-1);
                  await pageNotifier.resetProgress();
                },
                child: const Text('progress'),
              ),
              ElevatedButton(
                onPressed: cmdSVNNotifier.runImport,
                child: const Text('svn import'),
              ),
              ElevatedButton(
                onPressed: cmdSVNNotifier.runRename,
                child: const Text('run rename'),
              ),
              ElevatedButton(
                onPressed: cmdSVNNotifier.runCheckout,
                child: const Text('svn checkout'),
              ),
              ElevatedButton(
                onPressed: cmdSVNNotifier.runStaging,
                child: const Text('svn add .'),
              ),
              ElevatedButton(
                onPressed: cmdSVNNotifier.update,
                child: const Text('svn update'),
              ),
              ElevatedButton(
                onPressed: () => ConfigController().loadAppConfig(ref),
                child: const Text('load config'),
              ),
              ElevatedButton(
                onPressed: ConfigController().createEmptyAppConfig,
                child: const Text('create empty config'),
              ),
              ElevatedButton(
                onPressed: () async => ConfigController().saveAppConfig(ref),
                child: const Text('save config'),
              ),
            ],
          ),
          SizedBox(
            width: 200,
            child: TextField(
              onSubmitted: cmdSVNNotifier.runCommit,
              decoration: const InputDecoration(
                labelText: 'commit message',
              ),
            ),
          ),
          SingleChildScrollView(
            child: Text(
              '''
            savedProjects:
              ${projectsState.savedProjects.toString()}
            currentPjIndex:
              ${projectsState.currentPjIndex.toString()}
            currentPj:
              ${projectsState.currentPj.toString()}
            defaultWorkingDir:
              ${contentsState.defaultBackupDir?.path}
            
          ''',
            ),
          ),
          Text(
            'log:\n ${cmdSVNState.stdout}',
            style: const TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
