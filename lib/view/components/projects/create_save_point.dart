import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompPjCreateSavePoint extends HookConsumerWidget {
  const CompPjCreateSavePoint({super.key});
  @override
  AlertDialog build(BuildContext context, WidgetRef ref) {
    final savePointName = useState('yay');

    return AlertDialog(
      title: const Text(
        'セーブポイントを作成',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      icon: const Icon(Icons.save),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Divider(),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'セーブポイント名',
                border: OutlineInputBorder(),
              ),
            ),
            Text('yey'),
            Text('yey'),
            Text('yey'),
            Text('yey'),
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
