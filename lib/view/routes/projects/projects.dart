import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'helper/list.dart';

class PageProjects extends ConsumerWidget {
  const PageProjects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CompProjectsList();
  }
}
