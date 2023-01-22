import 'dart:convert';
import 'dart:io';

import '../model/class/svn.dart';
import '../model/helper/svn.dart';
import 'assets.dart';

class SvnRepository {
  Future<ProcessResult> runCommand({
    required Directory currentDirectory,
    required SvnExecs svnExecs,
    required List<String> args,
  }) async {
    final process = await Process.run(
      svnExecs.getFile().path,
      args,
      workingDirectory: currentDirectory.path,
      stdoutEncoding: Encoding.getByName('utf-8'),
    );
    await SvnHelper().handleSvnErr(process);
    return process;
  }

  Future<SvnRepositoryInfo> getRepositoryInfo(
    Directory workingDir,
  ) async {
    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: ['info', '--xml'],
    );

    final stdout = process.stdout.toString();
    return SvnHelper().parseRepositoryInfo(stdout);
  }

  Future<List<SvnRevisionLog>> getRevisionsLog(
    Directory workingDir,
  ) async {
    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: ['log', '-v', '--xml'],
    );

    final stdout = process.stdout.toString();
    return SvnHelper().parseRevisionInfo(stdout);
  }

  Future<List<SvnStatusEntry>> getSvnStatusEntries(
    Directory workingDir,
  ) async {
    final process = await runCommand(
      currentDirectory: workingDir,
      svnExecs: SvnExecs.svn,
      args: ['status', '--xml'],
    );

    final stdout = process.stdout.toString();
    return SvnHelper().parseStatusEntries(stdout);
  }
}
