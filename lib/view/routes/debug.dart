import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/error/handler.dart';
import '../../model/helper/config.dart';
import '../../repository/config.dart';
import '../../vm/contents.dart';
import '../../vm/page.dart';
import '../../vm/projects.dart';
import '../../vm/svn.dart';
import '../util/route.dart';

class PageDebug extends ConsumerWidget {
  const PageDebug({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsState = ref.watch(contentsProvider);
    final cmdSVNState = ref.watch(cmdSVNProvider);
    final cmdSVNNotifier = ref.read(cmdSVNProvider.notifier);
    final projectsState = ref.watch(projectsProvider);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Wrap(
              spacing: 40,
              runSpacing: 20,
              children: [
                ElevatedButton(
                  onPressed: () async => cmdSVNNotifier
                      .getPjStatus()
                      .catchError(AIBASErrHandler(context, ref).noticeErr),
                  child: const Text('svn status'),
                ),
                ElevatedButton(
                  onPressed: () async => cmdSVNNotifier
                      .runInfo()
                      .catchError(AIBASErrHandler(context, ref).noticeErr),
                  child: const Text('svn info'),
                ),
                ElevatedButton(
                  onPressed: () async => cmdSVNNotifier
                      .runLog()
                      .catchError(AIBASErrHandler(context, ref).noticeErr),
                  child: const Text('svn log'),
                ),
                ElevatedButton(
                  onPressed: () async => cmdSVNNotifier
                      .runCreate()
                      .catchError(AIBASErrHandler(context, ref).noticeErr),
                  child: const Text('svn create'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pageNotifier = ref.read(pageProvider.notifier);
                    await pageNotifier.resetProgress();

                    for (var i = 0; i <= 5; i++) {
                      pageNotifier.updateProgress(0.2 * i);
                      await Future<void>.delayed(
                        const Duration(milliseconds: 300),
                      );
                    }

                    await pageNotifier.completeProgress();
                  },
                  child: const Text('progress'),
                ),
                ElevatedButton(
                  onPressed: () async => cmdSVNNotifier
                      .runImport()
                      .catchError(AIBASErrHandler(context, ref).noticeErr),
                  child: const Text('svn import'),
                ),
                ElevatedButton(
                  onPressed: () async => cmdSVNNotifier
                      .runRename()
                      .catchError(AIBASErrHandler(context, ref).noticeErr),
                  child: const Text('run rename'),
                ),
                ElevatedButton(
                  onPressed: () async => cmdSVNNotifier
                      .runCheckout()
                      .catchError(AIBASErrHandler(context, ref).noticeErr),
                  child: const Text('svn checkout'),
                ),
                ElevatedButton(
                  onPressed: () async => cmdSVNNotifier
                      .runStaging()
                      .catchError(AIBASErrHandler(context, ref).noticeErr),
                  child: const Text('svn add .'),
                ),
                ElevatedButton(
                  onPressed: () async => cmdSVNNotifier
                      .update()
                      .catchError(AIBASErrHandler(context, ref).noticeErr),
                  child: const Text('svn update'),
                ),
                ElevatedButton(
                  onPressed: () => RouteController(ref).appInit(context),
                  child: const Text('appInit'),
                ),
                ElevatedButton(
                  onPressed: RepositoryAppConfig().writeEmptyAppConfig,
                  child: const Text('create empty config'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final appConfig =
                        AppConfigHelper().getCurrentAppConfig(ref);
                    await RepositoryAppConfig().saveAppConfig(appConfig);
                  },
                  child: const Text('save config'),
                ),
              ],
            ),
            SizedBox(
              width: 200,
              child: TextField(
                onSubmitted: (String message) async => cmdSVNNotifier
                    .runCommit(message)
                    .catchError(AIBASErrHandler(context, ref).noticeErr),
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
      ),
    );
  }
}
