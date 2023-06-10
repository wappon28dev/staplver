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

  static Future<ProcessResult> runCommand({
    required Directory currentDirectory,
    required SvnExecs svnExecs,
    required List<String> args,
  }) async {
    log.v('Executing svn command: `${svnExecs.name} ${args.join(' ')}` ...');

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
      ..v('Repository info:\n  $repositoryInfo')
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
      ..v('Revision log:\n  $revisionLog')
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
      ..v('Status entries:\n  $statusEntries')
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
      ..v('Update:\n  ${process.stdout}')
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
      ..v('Staging all:\n  ${process.stdout}')
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
      ..v('Commit:\n  ${process.stdout}')
      ..df('Running commit ($commitMessage)');
  }
}
