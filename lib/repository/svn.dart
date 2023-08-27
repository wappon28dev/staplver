import 'dart:convert';
import 'dart:io';

import '../model/class/svn.dart';
import '../model/helper/svn.dart';
import '../vm/log.dart';
import 'assets.dart';

String shellArgumentEscape(String stdin) {
  var escapedStdin = stdin;
  final needEscapeChar = ['^', '&', '<', '>', '|', '"', ' '];
  for (final char in needEscapeChar) {
    escapedStdin = stdin.replaceAll(char, '^$char');
  }
  return escapedStdin;
}

class SvnRepository {
  SvnRepository(this.workingDir);
  final Directory workingDir;

  // TODO: 将来的には private にする
  static Future<ProcessResult> runCommand({
    required Directory currentDirectory,
    required SvnExecs svnExecs,
    required List<String> args,
  }) async {
    log.t('Executing svn command: `${svnExecs.name} ${args.join(' ')}` ...');

    final execPath = await AssetsRepository().getSvnExecPath(svnExecs);
    final process = await Process.run(
      execPath.path,
      args,
      workingDirectory: currentDirectory.path,
      stdoutEncoding: Encoding.getByName('utf-8'),
    );

    SvnHelper.handleSvnErr(process);
    return process;
  }

  Future<SvnRepositoryInfo> getRepositoryInfo() async {
    log.ds('getting repository info');

    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: ['info', '--xml'],
    );
    final stdout = process.stdout.toString();
    final repositoryInfo = SvnHelper.parseRepositoryInfo(stdout);

    log
      ..t('Repository info:\n  $repositoryInfo')
      ..df('Getting repository info');
    return repositoryInfo;
  }

  Future<List<SvnRevisionLog>> getRevisionsLog() async {
    log.ds('getting revision log');

    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: ['log', '-v', '--xml'],
    );
    final stdout = process.stdout.toString();
    final revisionLog = SvnHelper.parseRevisionInfo(stdout);

    log
      ..t('Revision log:\n  $revisionLog')
      ..df('Getting revision log');
    return revisionLog;
  }

  Future<List<SvnStatusEntry>> getStatusEntries() async {
    log.ds('getting status entries');

    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: ['status', '--xml'],
    );
    final stdout = process.stdout.toString();
    final statusEntries = SvnHelper.parseStatusEntries(stdout);

    log
      ..t('Status entries:\n  $statusEntries')
      ..df('Getting status entries');
    return statusEntries;
  }

  Future<void> runUpdate() async {
    log.ds('running update');

    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: ['update'],
    );

    log
      ..t('Update:\n  ${process.stdout}')
      ..df('Running update');
  }

  Future<void> runStagingAll() async {
    log.ds('running staging all');

    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: ['add', '--force', './'],
    );

    log
      ..t('Staging all:\n  ${process.stdout}')
      ..df('Running staging all');
  }

  Future<void> runCommit(String commitMessage) async {
    log.ds('running commit ($commitMessage)');

    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: ['commit', '-m', shellArgumentEscape(commitMessage)],
    );

    log
      ..t('Commit:\n  ${process.stdout}')
      ..df('Running commit ($commitMessage)');
  }

  Future<void> runRevertRevision(int revisionId) async {
    log.ds('running revert');

    final rivLog = await getRevisionsLog();
    final rivLogIndex =
        rivLog.indexWhere((element) => element.revisionIndex == revisionId);

    if (rivLogIndex == -1) {
      throw Exception('Revision $revisionId is not found.');
    }

    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: [
        'merge',
        '-c',
        '-$revisionId',
        '.',
      ],
    );

    log
      ..t('Revert:\n  ${process.stdout}')
      ..df('Running revert');
  }

  Future<void> runRevert(String path) async {
    log.ds('running revert');

    final statusEntries = await getStatusEntries();
    final statusEntryIndex =
        statusEntries.indexWhere((element) => element.path == path);
    if (statusEntryIndex == -1) {
      throw Exception('Path $path is not found.');
    }

    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: [
        'revert',
        path,
      ],
    );

    log
      ..t('Revert:\n  ${process.stdout}')
      ..df('Running revert');
  }

  Future<void> runRevertAll() async {
    log.ds('running revert all');

    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: [
        'revert',
        '-R',
        '.',
      ],
    );

    log
      ..t('Revert all:\n  ${process.stdout}')
      ..df('Running revert all');
  }

  Future<void> runDelete(String path, {bool needForce = false}) async {
    log.ds('running delete');

    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: [
        'delete',
        if (needForce) '--force',
        path,
      ],
    );

    log
      ..t('Delete:\n  ${process.stdout}')
      ..df('Running delete');
  }
}
