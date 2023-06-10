import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:staplver/view/routes/projects/details.dart';
import 'package:staplver/vm/svn.dart';

class CompPjCreateSavePoint extends HookConsumerWidget {
  const CompPjCreateSavePoint({super.key});
  @override
  AlertDialog build(BuildContext context, WidgetRef ref) {
    final savePointName = useState('yay');

    // notifier
    final svnNotifier = ref.read(svnPod.notifier);

    Future<void> onSubmitted(String value) async {
      savePointName.value = value;
      await svnNotifier.createSavePoint(value);
      await CompProjectsDetails.refresh(ref, needUpdate: true);

      // ignore: use_build_context_synchronously
      Navigator.pop(context, savePointName.value);
    }

    return AlertDialog(
      title: const Text(
        'セーブポイントを作成',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      icon: const Icon(Icons.save),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'セーブポイント名',
                border: OutlineInputBorder(),
              ),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'セーブポイント名を入力してください';
                }
                return null;
              },
              onFieldSubmitted: onSubmitted,
            ),
            const Text('yey'),
            const Text('yey'),
            const Text('yey'),
            const Text('yey'),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        FilledButton.icon(
          label: const Text('作成'),
          icon: const Icon(Icons.save),
          onPressed: () => Navigator.pop(context, savePointName.value),
        ),
      ],
    );
  }
}
