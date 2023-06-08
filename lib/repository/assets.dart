import 'dart:io';

import 'package:flutter/foundation.dart';

import '../model/error/exception.dart';

enum SvnExecs {
  svn('svn'),
  svnAdmin('svnadmin'),
  svnBench('svnbench'),
  svnDumpFilter('svndumpfilter'),
  svnFsfs('svnfsfs'),
  svnLook('svnlook'),
  svnMucc('svnmucc'),
  svnRdump('svnrdump'),
  svnServe('svnserve'),
  svnSync('svnsync'),
  svnVersion('svnversion');

  const SvnExecs(this.name);
  final String name;

  File getFile() {
    final assetsDir = AssetsRepository().getAssetsAbsDir();
    final platform = Platform.isWindows ? 'windows' : 'linux';
    final binPath = '${assetsDir.path}/svn/$platform';

    final extension = Platform.isWindows ? '.exe' : '';
    final path = '$binPath/$name$extension';
    final file = File(path);

    return file;
  }
}

class AssetsRepository {
  Directory getAssetsAbsDir() {
    final debugRootDir = Directory(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;

    var releaseRootDir = Directory.current;

    if (Platform.isWindows) {
      final dataDir = Directory(Platform.resolvedExecutable).parent;
      releaseRootDir = Directory('${dataDir.path}/data');
    } else if (Platform.isMacOS) {
      final contentsDir = Directory(Platform.resolvedExecutable).parent.parent;
      releaseRootDir =
          Directory('${contentsDir.path}/Frameworks/App.framework/Resources');
    }

    if (kDebugMode) {
      return Directory('${debugRootDir.path}/assets');
    } else {
      return Directory('${releaseRootDir.path}/flutter_assets/assets');
    }
  }

  Future<File> getSvnExecPath(SvnExecs svnExecs) async {
    final file = svnExecs.getFile();

    return switch (await file.exists()) {
      true => file,
      false => throw AppExceptions().svnExecNotFound(svnExecs)
    };
  }
}
