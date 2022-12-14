import 'package:aibas/vm/page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Destination {
  Destination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
  Icon icon;
  Icon selectedIcon;
  String label;
}

class NavBar {
  NavBar({
    required this.ref,
    required this.orientation,
  });

  WidgetRef ref;
  Orientation orientation;

  List<Destination> dest = [
    Destination(
      icon: const Icon(Icons.home_outlined),
      selectedIcon: const Icon(Icons.home),
      label: 'ホーム',
    ),
    Destination(
      icon: const Icon(Icons.rocket_launch_outlined),
      selectedIcon: const Icon(Icons.rocket_launch),
      label: 'プロジェクト',
    ),
    Destination(
      icon: const Icon(Icons.settings_outlined),
      selectedIcon: const Icon(Icons.settings),
      label: '設定',
    ),
    Destination(
      icon: const Icon(Icons.bug_report_outlined),
      selectedIcon: const Icon(Icons.bug_report),
      label: 'デバッグ',
    ),
  ];

  FloatingActionButton? getFAB() {
    return orientation == Orientation.portrait
        ? FloatingActionButton(
            tooltip: '新規プロジェクトを作成',
            onPressed: () {
              // Add your onPressed code here!
            },
            child: const Icon(Icons.add),
          )
        : null;
  }

  Widget getBottomNavbar() {
    final pageState = ref.watch(pageProvider);
    final pageNotifier = ref.read(pageProvider.notifier);

    final bottomDest = <NavigationDestination>[];
    for (final element in dest) {
      bottomDest.add(
        NavigationDestination(
          icon: element.icon,
          selectedIcon: element.selectedIcon,
          label: element.label,
        ),
      );
    }

    return orientation == Orientation.portrait
        ? NavigationBar(
            selectedIndex: pageState.navbarIndex,
            onDestinationSelected: pageNotifier.updateNavbarIndex,
            destinations: bottomDest,
          )
        : const SizedBox();
  }

  Widget getRailsNavbar(
    Column mainContent,
  ) {
    final pageState = ref.watch(pageProvider);
    final pageNotifier = ref.read(pageProvider.notifier);

    final railDest = <NavigationRailDestination>[];
    for (final element in dest) {
      railDest.add(
        NavigationRailDestination(
          icon: element.icon,
          selectedIcon: element.selectedIcon,
          label: Text(element.label),
        ),
      );
    }

    final rails = NavigationRail(
      labelType: NavigationRailLabelType.all,
      selectedIndex: pageState.navbarIndex,
      onDestinationSelected: pageNotifier.updateNavbarIndex,
      leading: Column(
        children: [
          const Text('🐍', style: TextStyle(fontSize: 40)),
          Padding(
            padding: const EdgeInsets.all(8),
            child: FloatingActionButton(
              tooltip: '新規プロジェクトを作成',
              elevation: 0,
              onPressed: () {
                // Add your onPressed code here!
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      destinations: railDest,
    );

    return Row(
      children: [
        orientation == Orientation.landscape ? rails : const SizedBox(),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: mainContent),
      ],
    );
  }
}
