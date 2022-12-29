import 'dart:async';

import 'package:flutter/material.dart';

class SnackBarController {
  SnackBarController(this.context);

  final BuildContext context;

  // ignore: prefer_void_to_null
  FutureOr<Null> errHandlerSnack(dynamic err) {
    pushSnackBarErr(content: err.toString());
  }

  // ignore: prefer_void_to_null
  FutureOr<Null> errHandlerBanner(dynamic err) {
    pushBanner(content: err.toString());
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
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          content,
          style: TextStyle(color: colorScheme.onError),
        ),
        leading: Icon(Icons.error_outline, color: colorScheme.onError),
        backgroundColor: colorScheme.error,
        actions: [
          TextButton(
            child: Text(
              '無視する',
              style: TextStyle(color: colorScheme.onError),
            ),
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.restart_alt),
            label: const Text('修正する'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              backgroundColor: Theme.of(context).colorScheme.onError,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          )
        ],
      ),
    );
  }
}
