import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderables/reorderables.dart';

import '../../../../model/helper/config.dart';
import '../../../../vm/projects.dart';
import '../../../util/route.dart';
import 'details.dart';

class CompProjectsList extends ConsumerWidget {
  const CompProjectsList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectsProvider);
    final projects = projectsState.savedProjects;
    final projectsNotifier = ref.read(projectsProvider.notifier);

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
                  collapsed: ExpandableButton(
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            projectsNotifier.updateCurrentPjIndex(index);
                            RouteController.runPush(
                              context: context,
                              page: const CompProjectsDetails(),
                            );
                          },
                          icon: const Icon(Icons.info_outline),
                          label: const Text('詳細を見る'),
                        ),
                      ],
                    ),
                  ),
                  expanded: Column(
                    children: [
                      const Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed \n'
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed \n'
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed \n'
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed \n'
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed \n'
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed \n',
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

      ref.read(projectsProvider.notifier).updateSavedProject(clonedProjects);
      AppConfigHelper().updateAppConfig(ref);
    }

    return ReorderableSliverList(
      delegate: ReorderableSliverChildListDelegate(getPjCards()),
      onReorder: onReorder,
    );
  }
}
