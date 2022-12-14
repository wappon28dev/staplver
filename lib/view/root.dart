import 'package:aibas/view/components/navbar.dart';
import 'package:aibas/view/routes/debug.dart';
import 'package:aibas/view/routes/home.dart';
import 'package:aibas/view/routes/projects.dart';
import 'package:aibas/view/routes/settings.dart';
import 'package:aibas/vm/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final navbar = NavBar(ref: ref, orientation: orientation);

    final pageState = ref.watch(pageProvider);

    const pages = [
      PageHome(),
      PageProjects(),
      PageSettings(),
      PageDebug(),
    ];

    return Scaffold(
      bottomNavigationBar: navbar.getBottomNavbar(),
      floatingActionButton: navbar.getFAB(),
      body: pages[pageState.navbarIndex],
    );
  }
}
