import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../vm/projects.dart';
import '../../../components/navbar.dart';

class CompProjectsDetails extends ConsumerWidget {
  const CompProjectsDetails({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectsProvider);
    final project = projectsState.currentPj;

    final orientation = MediaQuery.of(context).orientation;

    if (project == null) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Text('No project selected'),
        ),
      );
    }

    final content = SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              project.toString(),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Text(
                  project.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 40,
                  ),
                ),
              ],
            ),
            leading: const SizedBox(),
            leadingWidth: 0,
            bottom: NavBar(ref: ref, orientation: orientation)
                .getProgressIndicator(),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              )
            ],
          ),
          content
        ],
      ),
    );
  }
}
