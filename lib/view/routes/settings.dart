import 'package:aibas/model/state.dart';
import 'package:aibas/view/components/navbar.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageSettings extends ConsumerWidget {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final navbar = NavBar(ref: ref, orientation: orientation);

    return navbar.getRailsNavbar(
      Column(
        children: <Widget>[
          Container(
            height: 100,
            child: Row(),
          ),
          Divider(
            thickness: 2,
          ),
          Text('data'),
        ],
      ),
    );
  }
}
