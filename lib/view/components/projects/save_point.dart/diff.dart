import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:staplver/model/class/svn.dart';
import 'package:staplver/model/constant.dart';

import '../../navbar.dart';

class CompPjSavePointDiff extends ConsumerWidget {
  const CompPjSavePointDiff({super.key, required this.savePoint});
  final SvnRevisionLog savePoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // local
    final orientation = MediaQuery.of(context).orientation;
    final paths = savePoint.paths;

    // view
    Widget getTiles() {
      final tiles = <Widget>[];
      final colorScheme = Theme.of(context).colorScheme;

      for (final entry in paths) {
        final textColor =
            entry.action.color.harmonizeWith(colorScheme.background);

        tiles.add(
          ListTile(
            title: Text(
              File(entry.filePath).name,
              style: TextStyle(
                color: textColor.harmonizeWith(colorScheme.background),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(entry.filePath),
            trailing: entry.action.chips(colorScheme),
            dense: true,
          ),
        );
      }
      return Column(children: tiles);
    }

    Widget content() {
      return Column(
        children: [const Text('Diff'), const Divider(), getTiles()],
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Text(
                  savePoint.message,
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
                  onPressed: () => Navigator.pop(context),
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
