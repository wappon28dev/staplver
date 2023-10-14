import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../model/class/app.dart';
import '../../vm/page.dart';
import '../routes/fab/checkout.dart';
import '../routes/fab/create_pj.dart';
import '../routes/fab/import_pj.dart';
import '../util/route.dart';

class NavBar {
  NavBar({
    required this.ref,
    required this.orientation,
  });

  WidgetRef ref;
  Orientation orientation;

  List<Destination> getDest() {
    return <Destination>[
      Destination(
        icon: const Icon(Icons.rocket_launch_outlined),
        selectedIcon: const Icon(Icons.rocket_launch),
        label: 'プロジェクト',
        runInit: () {},
      ),
      Destination(
        icon: const Icon(Icons.settings_outlined),
        selectedIcon: const Icon(Icons.settings),
        label: '設定',
        runInit: () {},
      ),
      Destination(
        icon: const Icon(Icons.bug_report_outlined),
        selectedIcon: const Icon(Icons.bug_report),
        label: 'デバッグ',
        runInit: () {},
      ),
    ];
  }

  Widget getFab(BuildContext context, {bool fromRails = false}) {
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
          onTap: () => RouteController.runPush(
            context: context,
            page: const PageCreatePj(),
          ),
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          labelBackgroundColor: colorScheme.primary,
          labelStyle: TextStyle(color: colorScheme.onPrimary),
          shape: const CircleBorder(),
        ),
        SpeedDialChild(
          child: const Icon(Icons.drive_file_move),
          label: '作業フォルダーからプロジェクトをインポート',
          onTap: () => RouteController.runPush(
            context: context,
            page: const PageImportPj(),
          ),
          shape: const CircleBorder(),
        ),
        SpeedDialChild(
          child: const Icon(Icons.folder_copy),
          label: 'バックアップフォルダーから作業コピーを取る',
          onTap: () => RouteController.runPush(
            context: context,
            page: const PageCheckout(),
          ),
          shape: const CircleBorder(),
        ),
      ],
    );
  }

  PreferredSize getProgressIndicator() {
    final pageState = ref.watch(pagePod);
    return PreferredSize(
      preferredSize: const Size.fromHeight(10),
      child: AnimatedOpacity(
        opacity: pageState.isVisibleProgressBar ? 1 : 0,
        duration: const Duration(milliseconds: 600),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          tween: Tween<double>(
            begin: 0,
            end: pageState.progress,
          ),
          builder: (context, value, _) => LinearProgressIndicator(
            value: pageState.progress != -1 ? value : null,
          ),
        ),
      ),
    );
  }

  Widget getBottomNavbar() {
    final pageState = ref.watch(pagePod);
    final pageNotifier = ref.read(pagePod.notifier);

    final bottomDest = <NavigationDestination>[];
    for (final element in getDest()) {
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
            onDestinationSelected: (newIndex) {
              getDest()[newIndex].runInit();
              pageNotifier.updateNavbarIndex(newIndex);
            },
            destinations: bottomDest,
          )
        : const SizedBox();
  }

  Widget getRailsNavbar(
    BuildContext context,
    Widget mainContent,
  ) {
    final pageState = ref.watch(pagePod);
    final pageNotifier = ref.read(pagePod.notifier);

    final railDest = <NavigationRailDestination>[];
    for (final element in getDest()) {
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
            child: getFab(context, fromRails: true),
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
          Expanded(child: mainContent),
        ],
      );
    } else {
      return Center(child: mainContent);
    }
  }
}
