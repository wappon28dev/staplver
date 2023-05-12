import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timelines/timelines.dart';

import '../../../model/class/svn.dart';
import '../../../model/error/handler.dart';
import '../../routes/projects/details.dart';
import 'create_save_point.dart';

class CompPjHistory extends HookConsumerWidget {
  const CompPjHistory({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // local
    final colorScheme = Theme.of(context).colorScheme;
    final savePointState = ref.watch(CompProjectsDetails.savePointsProvider);

    // view
    Widget content(List<SvnRevisionLog> savePoints) {
      TimelineTile getTimelineTile(
        SvnRevisionLog savePoint,
        // ignore: avoid_positional_boolean_parameters
        bool isTop,
        bool isLast,
      ) {
        return TimelineTile(
          oppositeContents: Padding(
            padding: const EdgeInsets.all(5),
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
          padding: const EdgeInsets.all(5),
          child: Text(
            (savePoints.length + 1).toString(),
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
          onPressed: () async {
            final savePointName = await showDialog<String>(
              context: context,
              builder: (context) => const CompPjCreateSavePoint(),
            );
            debugPrint(savePointName);
          },
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

      const title = Padding(
        padding: EdgeInsets.all(8),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          children: [
            Icon(Icons.history, size: 25),
            Text(
              'セーブポイントの履歴',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
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
            children: [
                  title,
                  const Divider(),
                  const SizedBox(height: 20),
                  topNode,
                ] +
                getTimelines(),
          ),
        ),
      );
    }

    return savePointState.when(
      data: content,
      error: (err, trace) => SystemErrorHandler(context, ref).getErrWidget(
        title: 'セーブポイントの状態の読み込みに失敗しました',
        err: err,
        trace: trace,
      ),
      loading: () => const Column(
        children: [
          SizedBox(height: 20),
          Text('セーブポイントの状態を読み込み中...'),
        ],
      ),
    );
  }
}
