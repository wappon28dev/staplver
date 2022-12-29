import 'dart:async';

import 'package:aibas/model/error/exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SnackBarController {
  SnackBarController(this.context, this.ref);

  final BuildContext context;
  final WidgetRef ref;

  // ignore: prefer_void_to_null
  FutureOr<Null> errHandlerSnack(dynamic err) {
    pushSnackBarErr(content: err.toString());
  }

  // ignore: prefer_void_to_null
  FutureOr<Null> errHandlerBanner(dynamic err) {
    if (err is AIBASException) {
      pushBanner(
        content: err.message,
        approachIcon: err.approachIcon,
        approachLabel: err.approachLabel,
        icon: err.icon,
        onClick: err.onClick,
      );
    } else {
      pushBanner(content: err.toString());
    }
  }

  void pushSnackBar({IconData? icon, required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.endToStart,
        content: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(content),
          ],
        ),
      ),
    );
  }

  void pushSnackBarSuccess({
    IconData icon = Icons.check,
    required String content,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              content,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void pushSnackBarErr({
    IconData icon = Icons.error_outline,
    required String content,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: colorScheme.onError),
            const SizedBox(width: 10),
            Text(
              content,
              style: TextStyle(color: colorScheme.onError),
            ),
          ],
        ),
        backgroundColor: colorScheme.error,
      ),
    );
  }

  void pushBanner({
    required String content,
    IconData icon = Icons.error_outline,
    String? approachLabel,
    IconData? approachIcon,
    void Function(BuildContext context, WidgetRef ref)? onClick,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          content,
          style: TextStyle(color: colorScheme.onError),
        ),
        leading: Icon(icon, color: colorScheme.onError),
        backgroundColor: colorScheme.error,
        actions: [
          TextButton(
            child: Text(
              approachLabel == null ? '閉じる' : '無視する',
              style: TextStyle(color: colorScheme.onError),
            ),
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          ),
          approachLabel != null
              ? ElevatedButton.icon(
                  icon: Icon(approachIcon),
                  label: Text(approachLabel),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    backgroundColor: Theme.of(context).colorScheme.onError,
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    onClick!(context, ref);
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
