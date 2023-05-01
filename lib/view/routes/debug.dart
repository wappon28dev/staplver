import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/error/handler.dart';
import '../../model/helper/config.dart';
import '../../repository/assets.dart';
import '../../repository/config.dart';
import '../../vm/contents.dart';
import '../../vm/page.dart';
import '../../vm/projects.dart';
import '../../vm/svn.dart';
import '../util/route.dart';

class PageDebug extends HookConsumerWidget {
  const PageDebug({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsState = ref.watch(contentsProvider);
    final svnNotifier = ref.read(svnProvider.notifier);
    final projectsState = ref.watch(projectsProvider);

    final temp = useState('');

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
                  onPressed: () async {
                    final svn = await AssetsRepository()
                        .getSvnExecPath(SvnExecs.svn)
                        .catchError(SystemErrorHandler(context, ref).noticeErr);
                    temp
                      ..value = svn.toString()
                      ..value += svn.existsSync().toString();
                  },
                  child: const Text('get assets path'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pjStatus = svnNotifier
                        .getPjStatus()
                        .catchError(SystemErrorHandler(context, ref).noticeErr);
                    temp.value = (await pjStatus).toString();
                  },
                  child: const Text('svn status'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final repoInfo = await svnNotifier
                        .getRepositoryInfo()
                        .catchError(SystemErrorHandler(context, ref).noticeErr);
                    temp.value = repoInfo.toString();
                  },
                  child: const Text('svn info'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final log = await svnNotifier
                        .getPjSavePoints()
                        .catchError(SystemErrorHandler(context, ref).noticeErr);
                    temp.value = log.toString();
                  },
                  child: const Text('svn log'),
                ),
                ElevatedButton(
                  onPressed: () async => svnNotifier
                      .runCreate()
                      .catchError(SystemErrorHandler(context, ref).noticeErr),
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
                  onPressed: () async => svnNotifier
                      .runImport()
                      .catchError(SystemErrorHandler(context, ref).noticeErr),
                  child: const Text('svn import'),
                ),
                ElevatedButton(
                  onPressed: () async => svnNotifier
                      .runRename()
                      .catchError(SystemErrorHandler(context, ref).noticeErr),
                  child: const Text('run rename'),
                ),
                ElevatedButton(
                  onPressed: () async => svnNotifier
                      .runCheckout()
                      .catchError(SystemErrorHandler(context, ref).noticeErr),
                  child: const Text('svn checkout'),
                ),
                ElevatedButton(
                  onPressed: () async => svnNotifier
                      .runStaging()
                      .catchError(SystemErrorHandler(context, ref).noticeErr),
                  child: const Text('svn add .'),
                ),
                ElevatedButton(
                  onPressed: () async => svnNotifier
                      .update()
                      .catchError(SystemErrorHandler(context, ref).noticeErr),
                  child: const Text('svn update'),
                ),
                ElevatedButton(
                  onPressed: () => RouteController(ref).appInit(context),
                  child: const Text('appInit'),
                ),
                ElevatedButton(
                  onPressed: AppConfigRepository().writeEmptyAppConfig,
                  child: const Text('create empty config'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final appConfig =
                        AppConfigHelper().getCurrentAppConfig(ref);
                    await AppConfigRepository().saveAppConfig(appConfig);
                  },
                  child: const Text('save config'),
                ),
              ],
            ),
            SizedBox(
              width: 200,
              child: TextField(
                onSubmitted: (String message) async => svnNotifier
                    .runCommit(message)
                    .catchError(SystemErrorHandler(context, ref).noticeErr),
                decoration: const InputDecoration(
                  labelText: 'commit message',
                ),
              ),
            ),
            SingleChildScrollView(
              child: Text(
                '''
              savedProjects:
                ${projectsState.savedProjects}
              currentPjIndex:
                ${projectsState.currentPjIndex}
              currentPj:
                ${projectsState.currentPj}
              defaultWorkingDir:
                ${contentsState.defaultBackupDir?.path}
              
            ''',
              ),
            ),
            Text('temp => ${temp.value}'),
          ],
        ),
      ),
    );
  }
}
