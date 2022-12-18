import 'dart:io';

import 'package:aibas/model/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Project {
  Project(this.name, this.workingDir, this.backupDir, this.backupMin);

  String name;
  Directory workingDir;
  Directory backupDir;
  int backupMin;
}

final projectsProvider = StateNotifierProvider<ProjectsNotifier, ProjectsState>(
  (ref) => ProjectsNotifier(),
);

class ProjectsNotifier extends StateNotifier<ProjectsState> {
  ProjectsNotifier() : super(const ProjectsState());

  void addProject(Project newProject) {
    debugPrint('newProject => $newProject');
    final savedProjectsClone = state.savedProjects?.toList();

    if (savedProjectsClone == null) return;
    savedProjectsClone.add(newProject);

    state = state.copyWith(savedProjects: savedProjectsClone);
  }
}
