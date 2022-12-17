import 'package:aibas/view/routes/create_pj.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/svn.dart';
import 'package:aibas/vm/theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompSetPjConfig extends ConsumerWidget {
  const CompSetPjConfig({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = CompCreatePjHelper();

    final pjNameState = ref.watch(pjNameProvider);
    final pjNameNotifier = ref.read(pjNameProvider.notifier);
    final workingDirState = ref.watch(workingDirProvider);
    final backupDirState = ref.watch(backupDirProvider);

    String getWorkingDirStr() {
      if (workingDirState != null) {
        return '${workingDirState.path} (指定済み)';
      } else {
        return throw Exception('contentsState.workingDirectory is null');
      }
    }

    String? getBackupDirStr() {
      if (backupDirState != null) {
        return '${backupDirState.path} (既定)';
      } else {
        return null;
      }
    }

    final pjNameField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: const [
              Icon(Icons.badge, size: 47),
              Text('プロジェクト名'),
            ],
          ),
        ),
        Expanded(
          flex: 12,
          child: TextFormField(
            autofocus: true,
            initialValue: workingDirState?.name ?? '',
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'プロジェクト名を入力してください';
              }
              return null;
            },
            onChanged: (newVal) => pjNameNotifier.state = newVal,
            decoration: InputDecoration(
              errorStyle:
                  myTextStyle(color: Theme.of(context).colorScheme.error),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              labelText: '重複しないプロジェクト名を入力',
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: pjNameState.isNotEmpty
              ? const Icon(Icons.check)
              : Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
        ),
      ],
    );

    final workingDirField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: const [
              Icon(Icons.folder, size: 47),
              Text('作業フォルダー'),
            ],
          ),
        ),
        Expanded(
          flex: 12,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: getWorkingDirStr(),
              enabled: false,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: workingDirState?.existsSync() ?? false
              ? const Icon(Icons.check)
              : Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
        ),
      ],
    );

    final backupDirField = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: const [
              Icon(Icons.folder_copy, size: 47),
              Text('バックアップ\nフォルダー', textAlign: TextAlign.center),
            ],
          ),
        ),
        Expanded(
          flex: 12,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: getBackupDirStr(),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const Expanded(child: Icon(Icons.check)),
      ],
    );

    return layout.wrap(
      context,
      ref,
      true,
      Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),
                pjNameField,
                Text(pjNameState),
                const SizedBox(height: 40),
                workingDirField,
                const SizedBox(height: 40),
                backupDirField,
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: TextButton.icon(
              label: const Text('リセット'),
              icon: const Icon(Icons.restart_alt),
              onPressed: null,
            ),
          ),
          const SizedBox(height: 20),
          const Text('asdfasdf')
        ],
      ),
    );
  }
}
