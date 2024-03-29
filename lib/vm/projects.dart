import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/class/app.dart';
import '../model/error/exception.dart';
import '../model/helper/config.dart';
import '../model/state.dart';
import '../repository/config.dart';
import 'log.dart';
import 'page.dart';
import 'svn.dart';

part 'projects.g.dart';

@Riverpod(keepAlive: true)
class Projects extends _$Projects {
  @override
  ProjectsState build() {
    return const ProjectsState();
  }

  void addSavedProject(Project newProject) {
    log.t('newProject:\n  $newProject');
    final savedProjectsClone = state.savedProjects.toList()..add(newProject);

    state = state.copyWith(savedProjects: savedProjectsClone);
  }

  void updateSavedProject(List<Project> newSavedProjects) {
    log.t('newProjects:\n  $newSavedProjects');
    state = state.copyWith(savedProjects: newSavedProjects);
  }

  void updateCurrentPjIndex(int newCurrentPjIndex) {
    log.t('newCurrentPjIndex:\n  $newCurrentPjIndex');
    assert((state.savedProjects.length) >= newCurrentPjIndex);
    state = state.copyWith(currentPjIndex: newCurrentPjIndex);
  }

  Future<void> initProject() async {
    final svnNotifier = ref.read(svnPod.notifier);
    final pageNotifier = ref.read(pagePod.notifier);

    updateCurrentPjIndex(state.savedProjects.length - 1);

    final queue = <Future<void> Function()>[
      svnNotifier.runCreate,
      svnNotifier.runImport,
      svnNotifier.runRename,
      svnNotifier.runCheckout,
      svnNotifier.runStaging,
      svnNotifier.update,
      () async {
        final currentPj = state.currentPj;

        if (currentPj == null) {
          throw ProjectExceptions().pjNotFound();
        }

        await PjConfigRepository(currentPj.backupDir).createNewPjConfig(
          PjConfigHelper.project2PjConfig(currentPj),
        );
      }
    ];

    log.i('initProject...');
    pageNotifier.updateProgress(0);

    for (var i = 0; i < queue.length; i++) {
      await queue[i]();
      pageNotifier.updateProgress(i / queue.length);
    }
    log.i('┗ Finish initProject!');
  }
}
