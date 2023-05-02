import 'dart:io';

import 'package:xml/xml.dart';

import '../class/svn.dart';
import '../error/exception.dart';

class SvnHelper {
  Future<void> handleSvnErr(ProcessResult process) async {
    if (process.exitCode == 0) return;

    final stderr = process.stderr.toString();

    if (stderr.contains('E155007')) {
      return Future.error(SystemExceptions().dirNotSVNRepo());
    }
    if (stderr.contains('E165002')) {
      return Future.error(SystemExceptions().dirAlreadySVNRepo());
    }

    throw Exception(stderr);
  }

  SvnRepositoryInfo parseRepositoryInfo(String xml) {
    final document = XmlDocument.parse(xml);
    final entryElement = document.findAllElements('entry').first;

    final kindName = entryElement.getAttribute('kind');
    final path = entryElement.getAttribute('path');
    final revision = int.parse(entryElement.getAttribute('revision')!);
    final url = Uri.parse(entryElement.findElements('url').first.text);
    final relativeUrl =
        Uri.parse(entryElement.findElements('relative-url').first.text);

    String getElementText(String element1, String element2) {
      return entryElement
          .findElements(element1)
          .first
          .findElements(element2)
          .first
          .text;
    }

    final repositoryRoot = Uri.parse(getElementText('repository', 'root'));
    final repositoryUuid = getElementText('repository', 'uuid');
    final workingCopyRoot = getElementText('wc-info', 'wcroot-abspath');

    final workingCopySchedule = getElementText('wc-info', 'schedule');
    final workingCopyDepth = getElementText('wc-info', 'depth');

    final author = getElementText('commit', 'author');
    final date = DateTime.parse(getElementText('commit', 'date'));

    if (kindName == null || path == null) {
      throw SystemExceptions().svnRepositoryInfoIsInvalid();
    }

    return SvnRepositoryInfo(
      kind: SvnKinds.values.byName(kindName),
      path: path,
      revision: revision,
      url: url,
      relativeUrl: relativeUrl,
      repositoryRoot: repositoryRoot,
      repositoryUuid: repositoryUuid,
      workingCopyRoot: workingCopyRoot,
      workingCopySchedule: workingCopySchedule,
      workingCopyDepth: workingCopyDepth,
      author: author,
      date: date,
    );
  }

  List<SvnRevisionPath> parseRevisionPaths(List<XmlNode> pathElements) {
    final paths = <SvnRevisionPath>[];

    for (final pathElement in pathElements) {
      if (pathElement.children.isEmpty) continue;

      final filePath = pathElement.text;
      final actionName = pathElement.getAttribute('action');
      final textMods = pathElement.getAttribute('text-mods') == 'true';
      final propMods = pathElement.getAttribute('prop-mods') == 'true';
      final kindName = pathElement.getAttribute('kind');

      if (actionName == null || kindName == null) {
        throw SystemExceptions().svnRevisionLogIsInvalid();
      }

      paths.add(
        SvnRevisionPath(
          filePath: filePath,
          action: SvnActions.byName(actionName),
          textMods: textMods,
          propMods: propMods,
          kind: SvnKinds.values.byName(kindName),
        ),
      );
    }

    return paths;
  }

  List<SvnRevisionLog> parseRevisionInfo(String xml) {
    final document = XmlDocument.parse(xml);
    final logEntries = document.findAllElements('logentry');
    final revisionLogs = <SvnRevisionLog>[];

    for (final logEntry in logEntries) {
      final revisionIndex = int.parse(logEntry.getAttribute('revision')!);
      final author = logEntry.findElements('author').first.text;
      final date = DateTime.parse(logEntry.findElements('date').first.text);
      final message = logEntry.findElements('msg').first.text;
      final pathElements = logEntry.findElements('paths').first.children;
      final paths = parseRevisionPaths(pathElements);

      revisionLogs.add(
        SvnRevisionLog(
          revisionIndex: revisionIndex,
          author: author,
          date: date,
          message: message,
          paths: paths,
        ),
      );
    }

    return revisionLogs;
  }

  List<SvnStatusEntry> parseStatusEntries(String xml) {
    final document = XmlDocument.parse(xml);
    final targetElement = document.findAllElements('target').first;
    final entryElements = targetElement.findAllElements('entry');
    final entries = <SvnStatusEntry>[];

    for (final entryElement in entryElements) {
      final path = entryElement.getAttribute('path');
      final wcStatusElement = entryElement.findElements('wc-status').first;

      final itemName = wcStatusElement.getAttribute('item');
      final props = wcStatusElement.getAttribute('props')!;

      if (itemName == null || path == null) {
        throw SystemExceptions().svnStatusIsInvalid();
      }

      final action = SvnActions.values.byName(itemName);

      switch (action) {
        case SvnActions.added:
        case SvnActions.deleted:
        case SvnActions.unversioned:
          entries.add(
            SvnStatusEntry(
              path: path,
              action: SvnActions.values.byName(itemName),
              props: props,
            ),
          );
          break;

        // ignore: no_default_cases
        default:
          final revision = wcStatusElement.getAttribute('revision');
          final commitElement = wcStatusElement.findElements('commit').first;
          final committedRevision = commitElement.getAttribute('revision');
          final date =
              DateTime.parse(commitElement.findElements('date').first.text);
          final author = commitElement.findElements('author').first.text;
          final copied = commitElement.getAttribute('copied') == 'true';

          if (committedRevision == null) {
            throw SystemExceptions().svnStatusIsInvalid();
          }

          entries.add(
            SvnStatusEntry(
              path: path,
              action: SvnActions.values.byName(itemName),
              props: props,
              revision: revision != null ? int.parse(revision) : null,
              copied: copied,
              commit: SvnStatusCommitInfo(
                author: author,
                revision: int.parse(committedRevision),
                date: date,
              ),
            ),
          );
          break;
      }
    }
    return entries;
  }
}
