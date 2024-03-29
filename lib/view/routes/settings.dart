import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../vm/contents.dart';

class PageSettings extends ConsumerWidget {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsState = ref.watch(contentsPod);

    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Icon(Icons.folder_copy, size: 47),
                    Text('既定のバックアップ\nフォルダー', textAlign: TextAlign.center),
                  ],
                ),
              ),
              Expanded(
                flex: 12,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: contentsState.defaultBackupDir?.path,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: contentsState.defaultBackupDir?.existsSync() ?? false
                    ? const Icon(Icons.check)
                    : Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
