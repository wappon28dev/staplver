import 'package:aibas/view/components/navbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageProjects extends ConsumerWidget {
  const PageProjects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final navbar = NavBar(ref: ref, orientation: orientation);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 100,
          child: Row(),
        ),
        const Divider(
          thickness: 2,
        ),
        const Text('data'),
        const Text('data'),
        const Text('data'),
        const Text('data'),
        const Text('data'),
        const Text('data'),
      ],
    );
  }
}
