import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:staplver/vm/log.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/constant.dart';
import '../../../model/error/handler.dart';
import '../../../vm/page.dart';
import '../../../vm/projects.dart';
import '../../../vm/svn.dart';
import '../../components/navbar.dart';
import '../../components/projects/create_save_point.dart';
import '../../components/projects/save_point.dart/history.dart';
import '../../components/projects/status.dart';

class CompProjectsDetails extends HookConsumerWidget {
  const CompProjectsDetails({super.key});

  static final repositoryProvider = FutureProvider.autoDispose(
    (ref) async => ref.read(svnPod.notifier).getRepositoryInfo(),
  );
  static final savePointsProvider = FutureProvider.autoDispose(
    (ref) async => ref.read(svnPod.notifier).getPjSavePoints(),
  );
  static final pjStatusProvider = FutureProvider.autoDispose(
    (ref) async => ref.read(svnPod.notifier).getPjStatus(),
  );

  static Future<void> refresh(WidgetRef ref, {bool needUpdate = false}) async {
    log.ds('Providers refresh');
    if (needUpdate) await ref.read(svnPod.notifier).runUpdate();
    ref
      ..invalidate(repositoryProvider)
      ..invalidate(savePointsProvider)
      ..invalidate(pjStatusProvider);
    log.df('Providers refresh');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // state
    final projectsState = ref.watch(projectsPod);
    final pj = projectsState.currentPj;

    // assert
    if (pj == null) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Text('プロジェクトが選択されていません'),
        ),
      );
    }

    // notifier
    final pageNotifier = ref.read(pagePod.notifier);

    // local
    final orientation = MediaQuery.of(context).orientation;
    final isLaunching = useState(false);
    final isRefreshing = useState(false);
    final repoInfoState = ref.watch(repositoryProvider);
    final savePointsState = ref.watch(savePointsProvider);
    final pjStatusState = ref.watch(pjStatusProvider);

    // init
    void init() {
      ref.read(pagePod.notifier)
        ..updateIsVisibleProgressBar(true)
        ..updateProgress(-1);
    }

    void dispose() => pageNotifier.hideProgress();

    useEffect(() => onMounted(init), []);

    useEffect(
      () => onMountedAsync(() async {
        // if (repoInfoState.hasError) {
        //   SystemErrorHandler(context, ref)
        //       .noticeErr(repoInfoState.error, repoInfoState.stackTrace);
        // }
        // if (savePointsState.hasError) {
        //   SystemErrorHandler(context, ref)
        //       .noticeErr(savePointsState.error, savePointsState.stackTrace);
        // }
        // if (pjStatusState.hasError) {
        //   SystemErrorHandler(context, ref)
        //       .noticeErr(pjStatusState.error, pjStatusState.stackTrace);
        // }

        if (!repoInfoState.isLoading &&
            !savePointsState.isLoading &&
            !pjStatusState.isLoading) {
          await pageNotifier.completeProgress();
        }
      }),
      [repoInfoState, savePointsState, pjStatusState],
    );

    // view
    final actionChips = [
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('監視ストップ'),
                avatar: const Icon(Icons.stop_circle_outlined),
                onPressed: () {},
              ),
              ActionChip(
                label: const Text('最新の情報へ更新'),
                avatar: isRefreshing.value
                    ? const Padding(
                        padding: EdgeInsets.all(2),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.refresh),
                iconTheme: IconThemeData(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                onPressed: !isRefreshing.value
                    ? () {
                        init();
                        refresh(ref);
                      }
                    : null,
              ),
              ActionChip(
                label: const Text('作業フォルダーを開く'),
                avatar: isLaunching.value
                    ? const Padding(
                        padding: EdgeInsets.all(2),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.folder_open),
                iconTheme: IconThemeData(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                onPressed: !isLaunching.value
                    ? () async {
                        isLaunching.value = true;
                        await launchUrl(pj.workingDir.uri);
                        isLaunching.value = false;
                      }
                    : null,
              ),
              ActionChip(
                label: const Text('プロジェクトの設定'),
                avatar: const Icon(Icons.settings),
                iconTheme: IconThemeData(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      const Divider(),
      const SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: Text('カスタム'),
                avatar: Icon(Icons.emoji_nature),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
      const Divider(),
    ];

    final info = [
      const IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: CompPjStatus()),
            SizedBox(child: VerticalDivider()),
            Expanded(child: CompPjSavePointHistory()),
          ],
        ),
      ),
    ];

    Widget content() {
      return repoInfoState.when(
        data: (_) => Column(
          children: [
            const SizedBox(height: 10),
            ...actionChips,
            ...info,
          ],
        ),
        error: (err, trace) => SystemErrorHandler(context, ref).getErrWidget(
          title: 'SVNへの問い合わせ中にエラーが発生しました',
          err: err,
          trace: trace,
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text('SVNからの応答を待っています...'),
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: pjStatusState.value?.isEmpty ?? true
          ? const SizedBox.shrink()
          : FloatingActionButton(
              onPressed: () async {
                final savePointName = await showDialog<String>(
                  context: context,
                  builder: (context) => const CompPjCreateSavePoint(),
                );
                debugPrint(savePointName);
              },
              tooltip: 'セーブポイントを作成',
              child: const Icon(Icons.save),
            ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Text(
                  pj.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 40,
                  ),
                ),
              ],
            ),
            leading: const SizedBox(),
            leadingWidth: 0,
            bottom: NavBar(ref: ref, orientation: orientation)
                .getProgressIndicator(),
            actions: [
              SizedBox(
                width: 60,
                child: IconButton(
                  onPressed: () {
                    dispose();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(child: content()),
        ],
      ),
    );
  }
}
