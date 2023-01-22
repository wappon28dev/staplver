import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timelines/timelines.dart';

import '../../../model/class/svn.dart';
import '../../../vm/projects.dart';
import '../../../vm/svn.dart';

class CompPjHistory extends HookConsumerWidget {
  const CompPjHistory({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // state
    final projectsState = ref.watch(projectsProvider);
    final pj = projectsState.currentPj;

    // notifier
    final svnNotifier = ref.read(svnProvider.notifier);

    // local
    final savePoints = useMemoized(() async => svnNotifier.getPjSavePoints());
    final savePointsSnapshot = useFuture(savePoints);
    final colorScheme = Theme.of(context).colorScheme;

    // view
    if (!savePointsSnapshot.hasData || savePointsSnapshot.data == null) {
      return const Center(
        child: Text('セーブポイントを読み込み中...'),
      );
    } else if (savePointsSnapshot.hasError) {
      return Center(
        child: Text(
          'セーブポイントの読み込みに失敗しました\n'
          '${savePointsSnapshot.error}}',
        ),
      );
    }

    TimelineTile getTimelineTile(
      SvnRevisionLog savePoint,
      // ignore: avoid_positional_boolean_parameters
      bool isTop,
      bool isLast,
    ) {
      return TimelineTile(
        oppositeContents: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(savePoint.revisionIndex.toString()),
        ),
        contents: Container(
          padding: const EdgeInsets.all(8),
          child: Text(savePoint.message),
        ),
        node: TimelineNode(
          indicator: const DotIndicator(),
          startConnector: SizedBox(
            height: 50,
            child: isTop
                ? const DashedLineConnector(
                    color: Colors.grey,
                    dash: 1,
                    gap: 3,
                  )
                : const SolidLineConnector(),
          ),
          endConnector: isLast ? const SolidLineConnector() : null,
        ),
      );
    }

    List<TimelineTile> getTimelines() {
      final timeline = <TimelineTile>[];
      final savePoints = savePointsSnapshot.data!;

      for (var i = 0; i < savePoints.length; i++) {
        final savePoint = savePoints[i];

        final isTop = i == 0;
        final isLast = i != savePoints.length - 1;

        timeline.add(
          getTimelineTile(savePoint, isTop, isLast),
        );
      }
      return timeline;
    }

    final topNode = TimelineTile(
      oppositeContents: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          (savePointsSnapshot.data!.length + 1).toString(),
          style: const TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      contents: TextButton.icon(
        label: const Text(
          '新しいセーブポイントを作成',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
        icon: const Icon(Icons.save),
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
        ),
        onPressed: () {},
      ),
      node: const TimelineNode(
        indicator: OutlinedDotIndicator(
          color: Colors.grey,
        ),
        endConnector: DashedLineConnector(
          color: Colors.grey,
          dash: 1,
          gap: 3,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: TimelineTheme(
        data: TimelineThemeData(
          nodePosition: 0.15,
          indicatorTheme: IndicatorThemeData(
            size: 20,
            color: colorScheme.primary,
          ),
          connectorTheme: ConnectorThemeData(
            space: 50,
            thickness: 5,
            color: colorScheme.primary,
          ),
        ),
        child: Column(
          children: [topNode] + getTimelines(),
        ),
      ),
    );
  }
}
