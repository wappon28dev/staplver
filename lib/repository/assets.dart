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
    final binPath = '${assetsDir.path}/svn/${Platform.operatingSystem}';

    final extension = Platform.isWindows ? '.exe' : '';
    final path = '$binPath/$name$extension';
    final file = File(path);

    return file;
  }
}

class AssetsRepository {
  Directory getAssetsAbsDir() {
    final rootDir = Directory.fromUri(Platform.script).parent;
    if (kDebugMode) {
      return Directory('${rootDir.path}/assets');
    } else {
      return Directory('${rootDir.path}/data/flutter_assets/assets');
    }
  }

  Future<File> getSvnExecPath(SvnExecs svnExecs) async {
    final file = svnExecs.getFile();

    if (!await file.exists()) {
      return Future.error(AIBASExceptions().svnExecNotFound(svnExecs));
    }

    return Future.value(file);
  }
}
