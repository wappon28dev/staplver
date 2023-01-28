import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/class/app.dart';
import '../model/helper/config.dart';
import '../model/state.dart';
import '../repository/config.dart';
import 'page.dart';
import 'svn.dart';

final projectsProvider = StateNotifierProvider<ProjectsNotifier, ProjectsState>(
  ProjectsNotifier.new,
);

class ProjectsNotifier extends StateNotifier<ProjectsState> {
  ProjectsNotifier(this.ref) : super(const ProjectsState());

  final Ref ref;

  void addSavedProject(Project newProject) {
    debugPrint('newProject => $newProject');
    final savedProjectsClone = state.savedProjects.toList()..add(newProject);

    state = state.copyWith(savedProjects: savedProjectsClone);
  }

  void updateSavedProject(List<Project> newSavedProjects) {
    debugPrint('newProjects => $newSavedProjects');
    state = state.copyWith(savedProjects: newSavedProjects);
  }

  void updateCurrentPjIndex(int newCurrentPjIndex) {
    debugPrint('newCurrentPjIndex => $newCurrentPjIndex');
    assert((state.savedProjects.length) >= newCurrentPjIndex);
    state = state.copyWith(currentPjIndex: newCurrentPjIndex);
  }

  Future<void> initProject() async {
    final svnNotifier = ref.read(svnProvider.notifier);
    final pageNotifier = ref.read(pageProvider.notifier);

    updateCurrentPjIndex(state.savedProjects.length - 1);

    final queue = [
      () async => svnNotifier.runCreate(),
      () async => svnNotifier.runImport(),
      () async => svnNotifier.runRename(),
      () async => svnNotifier.runCheckout(),
      () async => svnNotifier.runStaging(),
      () async => svnNotifier.update(),
      () async => PjConfigRepository().createNewPjConfig(
            PjConfigHelper().project2PjConfig(state.currentPj!),
          )
    ];

    debugPrint('-- init project --');
    pageNotifier.updateProgress(0);

    for (var i = 0; i < queue.length; i++) {
      await queue[i]();
      pageNotifier.updateProgress(i / queue.length);
    }
    debugPrint('-- end --');
  }
}
