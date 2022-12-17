import 'package:aibas/vm/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageCreateProject extends ConsumerWidget {
  const PageCreateProject({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          '新規プロジェクトの作成 (1/3)',
          style: myTextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  Text('data'),
                ],
              ),
            ),
          ),
          Container(height: 40, color: Colors.amber),
        ],
      ),
    );
  }
}
