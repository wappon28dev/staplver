import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/svn.dart';
import 'package:aibas/vm/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageDebug extends ConsumerWidget {
  const PageDebug({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final contentsState = ref.watch(contentsProvider);
    final cmdSVNState = ref.watch(cmdSVNProvider);
    final cmdSVNNotifier = ref.read(cmdSVNProvider.notifier);

    return Column(
      children: <Widget>[
        Text(
          'working => ${contentsState.defaultBackupDir?.path}',
        ),
        Text(themeState.themeMode.name),
        Text('log =>\n ${cmdSVNState.stdout}'),
        ElevatedButton(
          onPressed: cmdSVNNotifier.runCreate,
          child: const Text('svn create'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: cmdSVNNotifier.runImport,
          child: const Text('svn import'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: cmdSVNNotifier.runRename,
          child: const Text('run rename'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: cmdSVNNotifier.runCheckout,
          child: const Text('svn checkout'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: cmdSVNNotifier.runStaging,
          child: const Text('svn add .'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: cmdSVNNotifier.update,
          child: const Text('svn update'),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          child: TextField(
            onSubmitted: cmdSVNNotifier.runCommit,
            decoration: const InputDecoration(
              labelText: 'Input',
            ),
          ),
        ),
      ],
    );
  }
}
