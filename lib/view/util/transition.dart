import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteController {
  RouteController(this.context, this.ref);
  BuildContext context;
  WidgetRef ref;

  static void runPush({
    required BuildContext context,
    required Widget page,
    required bool isReplace,
  }) =>
      !isReplace
          ? Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => page,
              ),
            )
          : Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(builder: (context) => page),
              (_) => false,
            );
}
