import 'dart:convert';
import 'dart:io';

import '../model/class/svn.dart';
import '../model/helper/svn.dart';

enum SVNBaseCmd {
  svn,
  svnadmin,
  mkdir,
}

class RepositorySVN {
  Future<String> _runCommand({
    required Directory currentDirectory,
    required SVNBaseCmd baseCmd,
    required List<String> args,
  }) async {
    Directory.current = currentDirectory;
    final process = await Process.run(
      baseCmd.name,
      args,
      stdoutEncoding: Encoding.getByName('utf-8'),
    );
    return process.stdout as String;
  }

  Future<SvnRepositoryInfo> getRepositoryInfo(Directory workingDir) async {
    final stdout = await _runCommand(
      currentDirectory: workingDir,
      baseCmd: SVNBaseCmd.svn,
      args: ['info', '--xml'],
    );
    final repositoryInfo = SvnHelper().parseRepositoryInfo(stdout);

    final repoJson = jsonEncode(repositoryInfo.toJson());
    print(repoJson);

    return repositoryInfo;
  }

  Future<List<SvnRevisionLog>> getRevisionsLog(
    Directory workingDir,
  ) async {
    final stdout = await _runCommand(
      currentDirectory: workingDir,
      baseCmd: SVNBaseCmd.svn,
      args: ['log', '-v', '--xml'],
    );
    final revisionLog = SvnHelper().parseRevisionInfo(stdout);

    final revJson = jsonEncode(revisionLog.map((e) => e.toJson()).toList());
    print(revJson);

    return revisionLog;
  }

  Future<List<SvnStatusEntry>> getSvnStatusEntries(
    Directory workingDir,
  ) {
    return _runCommand(
      currentDirectory: workingDir,
      baseCmd: SVNBaseCmd.svn,
      args: ['status', '--xml'],
    ).then((stdout) {
      final statusEntries = SvnHelper().parseStatusEntries(stdout);
      final statusJson =
          jsonEncode(statusEntries.map((e) => e.toJson()).toList());
      print(statusJson);

      return statusEntries;
    });
  }
}
