import 'package:aibas/model/data/class.dart';
import 'package:aibas/view/routes/fab/create_pj.dart';
import 'package:aibas/view/util/transition.dart';
import 'package:aibas/vm/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class NavBar {
  NavBar({
    required this.ref,
    required this.orientation,
  });

  WidgetRef ref;
  Orientation orientation;

  static List<Destination> dest = [
    const Destination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'ホーム',
    ),
    const Destination(
      icon: Icon(Icons.rocket_launch_outlined),
      selectedIcon: Icon(Icons.rocket_launch),
      label: 'プロジェクト',
    ),
    const Destination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: '設定',
    ),
    const Destination(
      icon: Icon(Icons.bug_report_outlined),
      selectedIcon: Icon(Icons.bug_report),
      label: 'デバッグ',
    ),
  ];

  Widget fab(BuildContext context, {bool fromRails = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      elevation: fromRails ? 0 : 4,
      direction: fromRails ? SpeedDialDirection.down : SpeedDialDirection.up,
      switchLabelPosition: fromRails,
      foregroundColor: colorScheme.onPrimary,
      backgroundColor: colorScheme.primary,
      activeForegroundColor: colorScheme.onSurfaceVariant,
      activeBackgroundColor: colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      spaceBetweenChildren: 13,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.rocket_launch),
          label: '新規プロジェクト作成',
          onTap: () {
            RouteController(ref).home2fab();
            RouteController.runPush(
              context: context,
              page: const PageCreatePj(),
              isReplace: false,
            );
          },
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          labelBackgroundColor: colorScheme.primary,
          labelStyle: TextStyle(color: colorScheme.onPrimary),
          shape: const CircleBorder(),
        ),
        SpeedDialChild(
          child: const Icon(Icons.drive_file_move),
          label: '作業フォルダーからプロジェクトをインポート',
          onTap: () => null,
          shape: const CircleBorder(),
        ),
        SpeedDialChild(
          child: const Icon(Icons.folder_copy),
          label: 'バックアップフォルダーから作業コピーを取る',
          onTap: () => null,
          shape: const CircleBorder(),
        ),
      ],
    );
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
    BuildContext context,
    Widget mainContent,
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
            child: fab(context, fromRails: true),
          ),
        ],
      ),
      destinations: railDest,
    );

    if (orientation == Orientation.landscape) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rails,
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: mainContent)
        ],
      );
    } else {
      return Center(child: mainContent);
    }
  }
}
