import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reorderables/reorderables.dart';

import '../../../../model/helper/config.dart';
import '../../../../vm/projects.dart';
import '../../../model/constant.dart';
import '../../../vm/page.dart';
import '../../util/route.dart';
import 'details.dart';

class PageProjects extends HookConsumerWidget {
  const PageProjects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // state
    final projectsState = ref.watch(projectsPod);

    // notifier
    final projectsNotifier = ref.read(projectsPod.notifier);
    final pageNotifier = ref.read(pagePod.notifier);

    // local
    final projects = projectsState.savedProjects;

    // init
    Future<void> init() async => pageNotifier.hideProgress();
    useEffect(() => onMountedAsync(init), []);

    // view
    List<Widget> getPjCards() {
      final cards = <Widget>[];

      for (var index = 0; index < projects.length; index++) {
        final pj = projects[index];
        cards.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ExpandablePanel(
                  header: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.folder),
                        SizedBox(width: 10),
                      ],
                    ),
                    title: Text(pj.name),
                    subtitle: Text(
                      pj.name,
                    ),
                  ),
                  collapsed: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.info_outline),
                          label: const Text('詳細を見る'),
                          onPressed: () {
                            projectsNotifier.updateCurrentPjIndex(index);
                            RouteController.runPush(
                              context: context,
                              page: const CompProjectsDetails(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  expanded: Column(
                    children: [
                      const Text(
                        'Lorem ipsum dolor sit \n'
                        'Lorem ipsum dolor sit \n'
                        'Lorem ipsum dolor sit \n'
                        'Lorem ipsum dolor sit \n'
                        'Lorem ipsum dolor sit \n'
                        'Lorem ipsum dolor sit \n',
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.info_outline),
                        label: const Text('詳細を見る'),
                      ),
                    ],
                  ),
                  theme: ExpandableThemeData(
                    iconColor: Theme.of(context).colorScheme.onBackground,
                    tapBodyToExpand: true,
                    tapBodyToCollapse: true,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      return cards;
    }

    void onReorder(int oldIndex, int newIndex) {
      final clonedProjects = projects.toList()
        ..removeAt(oldIndex)
        ..insert(newIndex, projects[oldIndex]);

      ref.read(projectsPod.notifier).updateSavedProject(clonedProjects);
      AppConfigHelper().updateAppConfig(ref);
    }

    return ReorderableSliverList(
      delegate: ReorderableSliverChildListDelegate(getPjCards()),
      onReorder: onReorder,
    );
  }
}
