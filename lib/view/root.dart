import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:window_manager/window_manager.dart';

import '../vm/now.dart';
import '../vm/page.dart';
import 'components/navbar.dart';
import 'routes/debug.dart';
import 'routes/home.dart';
import 'routes/projects/projects.dart';
import 'routes/settings.dart';
import 'util/route.dart';
import 'util/window.dart';

class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({super.key});

  @override
  ConsumerState<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    windowInit();
    RouteController(ref).appInit(context);
    super.initState();
  }

  void windowInit() {
    windowManager.setPreventClose(true);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Future<void> onWindowClose() async =>
      WindowController(context: context, ref: ref).onWindowClose();

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final navbar = NavBar(ref: ref, orientation: orientation);
    final isPortrait = orientation == Orientation.portrait;

    final pageState = ref.watch(pageProvider);
    final nowState = ref.watch(nowProvider);
    final dateStr =
        DateFormat.yMMMMEEEEd('ja').format(nowState.value ?? DateTime.now());
    final timeStr = DateFormat.Hms().format(nowState.value ?? DateTime.now());
    final dest = NavBar(ref: ref, orientation: orientation).getDest();

    const pages = [
      PageHome(),
      PageProjects(),
      PageSettings(),
      PageDebug(),
    ];

    final content = CustomScrollView(
      slivers: <Widget>[
        SliverAppBar.large(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Staplver',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 40,
                ),
              ),
              Text(
                ' / ${dest[pageState.navbarIndex].label}',
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          leading: const SizedBox(),
          leadingWidth: 0,
          bottom:
              NavBar(ref: ref, orientation: orientation).getProgressIndicator(),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: AutoSizeText.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '$dateStr・',
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    TextSpan(
                      text: timeStr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
                minFontSize: 20,
                maxLines: 1,
              ),
            ),
          ],
        ),
        pages[pageState.navbarIndex],
      ],
    );

    return Scaffold(
      bottomNavigationBar: navbar.getBottomNavbar(),
      floatingActionButton: isPortrait ? navbar.getFab(context) : null,
      body: navbar.getRailsNavbar(context, content),
    );
  }
}
