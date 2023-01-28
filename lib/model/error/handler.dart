import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/app.dart';

class AIBASErrHandler {
  AIBASErrHandler(this.context, this.ref);

  final BuildContext context;
  final WidgetRef ref;

  void pushSnackBar({
    IconData? icon,
    required String title,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }

  void pushBanner({
    required String title,
    IconData icon = Icons.error_outline,
    required List<ExceptionAction> actions,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final actionButtons = actions
        .map(
          (action) => action.isPrimary
              ? ElevatedButton.icon(
                  icon: Icon(action.icon),
                  label: Text(action.title),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    backgroundColor: Theme.of(context).colorScheme.onError,
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
                  onPressed: () => action.onClick?.call(context, ref),
                )
              : action.icon != null
                  ? TextButton.icon(
                      icon: Icon(action.icon),
                      label: Text(action.title),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onError,
                      ),
                      onPressed: () => action.onClick?.call(context, ref),
                    )
                  : TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onError,
                      ),
                      onPressed: () => action.onClick?.call(context, ref),
                      child: Text(action.title),
                    ),
        )
        .toList();

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          title,
          style: TextStyle(color: colorScheme.onError),
        ),
        leading: Icon(icon, color: colorScheme.onError),
        backgroundColor: colorScheme.error,
        actions: actionButtons,
      ),
    );
  }

  FutureOr<void> noticeErr(dynamic err, StackTrace trace) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

    debugPrint('=== Err Received ===\n$err\n$trace');
    debugPrintStack();
    if (err is AIBASException) {
      debugPrint(err.message);
      if (err.needShowAsBanner) {
        pushBanner(
          title: err.message,
          icon: err.icon,
          actions: err.actions ?? [],
        );
      } else {
        SnackBarController(context, ref).pushSnackBarErr(title: err.message);
      }
    } else {
      _noticeUnhandledErr(err, trace);
    }
  }

  void _noticeUnhandledErr(dynamic err, StackTrace trace) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

    debugPrint('=== UnhandledErr Received ===\n$err\n$trace');
    pushBanner(
      title: '開発者の想定していないエラーが発生しました\n$err',
      actions: [
        ExceptionAction(
          title: '閉じる',
          icon: Icons.close,
          isPrimary: false,
          onClick: (context, ref) =>
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
        ),
      ],
    );
  }
}

class SnackBarController {
  SnackBarController(this.context, this.ref);

  final BuildContext context;
  final WidgetRef ref;

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
    required String title,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            Icon(icon, color: colorScheme.onError),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(color: colorScheme.onError),
            ),
          ],
        ),
        backgroundColor: colorScheme.error,
      ),
    );
  }
}
