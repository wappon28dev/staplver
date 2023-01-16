import 'dart:io';

import '../model/error/exception.dart';

enum SVNInfo {
  path('Path'),
  workingDirPath('Working Copy Root Path'),
  backupDirUrl('URL'),
  relativeUrl('Relative URL'),
  repositoryUrl('Repository Root'),
  repositoryUUID('Repository UUID'),
  savePointLength('Revision'),
  nodeKind('Node Kind'),
  schedule('Schedule'),
  lastChangedAuthor('Last Changed Author'),
  lastChangedRev('Last Changed Rev'),
  lastChangedData('Last Changed Date');

  const SVNInfo(this.key);
  final String key;

  String? extractKey(String data) {
    // ignore: prefer_interpolation_to_compose_strings
    final reg = RegExp(r'(?<=' + key + ': )(.*)');
    final uriStr = reg.firstMatch(data)?.group(0);
    return uriStr;
  }
}

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
    final process = await Process.run(SVNBaseCmd.svn.name, args);
    return process.stdout as String;
  }

  Future<String> getSVNInfo(
    Directory workingOrBackupDir,
    SVNInfo infoKind,
  ) async {
    final stdout = await _runCommand(
      currentDirectory: workingOrBackupDir,
      baseCmd: SVNBaseCmd.svn,
      args: ['info'],
    );

    final info = infoKind.extractKey(stdout);
    if (stdout.isEmpty || info == null) {
      return Future.error(AIBASExceptions().svnInfoIsInvalid());
    }
    return info;
  }
}
