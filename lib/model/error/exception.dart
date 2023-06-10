// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:staplver/vm/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../repository/assets.dart';
import '../../repository/config.dart';
import '../../view/util/route.dart';
import '../../vm/page.dart';
import '../../vm/projects.dart';
import '../class/app.dart';
import '../constant.dart';
import '../helper/config.dart';

sealed class SystemExceptions {}

final class AppExceptions extends SystemExceptions {
  SystemException svnExecNotFound(SvnExecs svnExecs) => SystemException(
        message: '''
${svnExecs.name}の実行ファイルが見つかりませんでした  ファイルを元の場所に復元するか, 再インストールを行ってください
予期したファイルパス: ${svnExecs.getFile().path}''',
        icon: Icons.broken_image,
        needShowAsBanner: true,
        actions: [
          ExceptionAction(
            title: 'アプリを終了',
            icon: Icons.close,
            onClick: (BuildContext context, WidgetRef ref) => exit(0),
          ),
          ExceptionAction(
            title: 'ダウンロードページへ',
            isPrimary: true,
            icon: Icons.download,
            onClick: (BuildContext context, WidgetRef ref) async {
              final pageNotifier = ref.read(pagePod.notifier);
              await pageNotifier.resetProgress();
              pageNotifier.updateProgress(0.3);
              await launchUrl(gitHubReleaseUrl);
              await pageNotifier.completeProgress();
            },
          ),
        ],
      );
}

base class ConfigExceptions extends SystemExceptions {
  ExceptionAction _getInitSpecSettingAction(
    void Function(WidgetRef ref) updater,
  ) =>
      ExceptionAction(
        title: '該当の設定を初期値に戻す',
        isPrimary: true,
        icon: Icons.delete_forever,
        onClick: (BuildContext context, WidgetRef ref) async {
          final pageNotifier = ref.read(pagePod.notifier);
          await pageNotifier.resetProgress();
          pageNotifier.updateProgress(0.3);
          updater(ref);
          await AppConfigHelper.updateAppConfig(ref);
          await pageNotifier.completeProgress();

          RouteController.runPush(
            context: context,
            page: const Staplver(),
            isReplace: true,
          );
        },
      );
  ExceptionAction _getInitAllSettingAction() => ExceptionAction(
        title: '空の設定ファイルで上書きする',
        isPrimary: true,
        icon: Icons.restart_alt,
        onClick: (BuildContext context, WidgetRef ref) {
          RouteController.runPush(
            context: context,
            page: const Staplver(),
            isReplace: true,
          );
        },
      );

  SystemException dirNotFound({
    required bool isBackupDir,
    required Directory missingDir,
  }) =>
      SystemException(
        message: '''
${isBackupDir ? 'バックアップ' : '作業'}フォルダーが見つかりません
紛失フォルダー: ${missingDir.path}
''',
        icon: Icons.search_off,
      );
}

final class AppConfigExceptions extends ConfigExceptions {
  SystemException configNotFound() =>
      const SystemException(message: 'アプリの設定ファイルが見つかりません');

  SystemException cannotLoad(
    String? osMessage,
  ) {
    return SystemException(
      message: osMessage == null
          ? 'アプリの設定ファイルは次の理由で読み込めませんでした:\n$osMessage'
          : '不明な理由で, アプリの設定ファイルを読み込めません',
    );
  }

  SystemException invalid() => SystemException(
        message: 'アプリの設定ファイルが壊れています',
        needShowAsBanner: true,
        icon: Icons.broken_image,
        actions: [
          ExceptionAction(
            title: '設定フォルダーを開く',
            icon: Icons.folder_open,
            onClick: (BuildContext context, WidgetRef ref) async {
              final file = await AppConfigRepository().appConfigFile;
              await launchUrl(file.parent.uri);
              exit(0);
            },
          ),
          ExceptionAction(
            title: '空の設定ファイルで上書きする',
            isPrimary: true,
            icon: Icons.restart_alt,
            onClick: (BuildContext context, WidgetRef ref) {
              AppConfigRepository().writeEmptyAppConfig();
              RouteController.runPush(
                context: context,
                page: const Staplver(),
                isReplace: true,
              );
            },
          ),
        ],
      );
}

final class PjConfigExceptions extends ConfigExceptions {
  SystemException configNotFound() =>
      const SystemException(message: 'プロジェクトの設定ファイルが見つかりません');

  SystemException dirNotFoundDetails({
    required bool isBackupDir,
    required Directory backupDir,
    required Directory workingDir,
  }) =>
      SystemException(
        message: '''
プロジェクトをロードしましたが, ${isBackupDir ? 'バックアップ' : '作業'}フォルダーが見つかりませんでした

バックアップフォルダー: ${backupDir.path}
作業フォルダー　　　　: ${workingDir.path}
''',
        needShowAsBanner: true,
        actions: [
          ExceptionAction(
            title: '無視する',
            onClick: (BuildContext context, WidgetRef ref) =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          ),
          ExceptionAction(
            title: '該当のプロジェクトをアプリの設定から削除する',
            isPrimary: true,
            icon: Icons.delete_forever,
            onClick: (BuildContext context, WidgetRef ref) async {
              final pageNotifier = ref.read(pagePod.notifier);

              await pageNotifier.resetProgress();
              pageNotifier.updateProgress(0.3);
              await AppConfigRepository().removeSavedProject(backupDir);
              await pageNotifier.completeProgress();

              RouteController.runPush(
                context: context,
                page: const Staplver(),
                isReplace: true,
              );
            },
          ),
        ],
      );

  SystemException cannotLoad(
    String? osMessage,
  ) {
    return SystemException(
      message: osMessage == null
          ? 'プロジェクトの設定ファイルは次の理由で読み込めませんでした:\n$osMessage'
          : '不明な理由で, アプリの設定ファイルを読み込めません',
    );
  }

  SystemException invalid() => SystemException(
        message: 'プロジェクトの設定ファイルが壊れています',
        needShowAsBanner: true,
        icon: Icons.broken_image,
        actions: [
          ExceptionAction(
            title: '設定フォルダーを開く',
            icon: Icons.folder_open,
            onClick: (BuildContext context, WidgetRef ref) async {
              final backupDir = ref.read(projectsPod).currentPj!.backupDir;
              final path = File('${backupDir.path}/staplver/pj_config.json');
              await launchUrl(path.parent.uri);
              exit(0);
            },
          ),
          _getInitAllSettingAction(),
        ],
      );

  SystemException pjNameIsInvalid() => const SystemException(
        message: 'プロジェクト名が不正です',
      );
  SystemException backupMinIsInvalid() => const SystemException(
        message: 'バックアップ頻度が不正です',
      );
  SystemException pjConfigIsNull() => const SystemException(
        message: 'プロジェクトの設定ファイルに問題があるようです',
      );

  SystemException themeModeIsInvalid() => SystemException(
        message: 'アプリの設定ファイル内: ThemeModeが不正です',
        needShowAsBanner: true,
        actions: [
          ExceptionAction(
            title: '無視する',
            onClick: (BuildContext context, WidgetRef ref) =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          ),
          _getInitSpecSettingAction(
            (ref) => ref
                .read(appThemePod.notifier)
                .updateThemeMode(ThemeMode.system),
          )
        ],
      );
}

final class ProjectExceptions extends SystemExceptions {
  SystemException currentPjIsNull() => const SystemException(
        message: '現在のプロジェクトが見つかりません',
      );

  SystemException pjNotFound() => const SystemException(
        message: 'バックアップフォルダーはSVNリポジトリですが, staplverプロジェクトではありません',
      );
  SystemException pjAlreadyExists() => const SystemException(
        message: 'staplverプロジェクトは既に存在します',
      );
  SystemException importedPjIsNull() => const SystemException(
        message: 'インポートしたプロジェクトに問題があるようです',
      );
}

final class SvnExceptions extends SystemExceptions {
  SystemException dirAlreadySVNRepo() => const SystemException(
        message: 'SVNリポジトリは既に存在します',
      );
  SystemException dirNotSVNRepo() => const SystemException(
        message: 'SVNリポジトリではありません',
      );
  SystemException repositoryInfoIsInvalid([String? details]) => SystemException(
        message: 'SVNリポジトリログのXMLが不正です ($details)',
      );
  SystemException revisionLogIsInvalid([String? details]) => SystemException(
        message: 'SVNログのXMLが不正です ($details)',
      );
  SystemException statusIsInvalid([String? details]) => SystemException(
        message: 'SVNステータスのXMLが不正です ($details)',
      );
}
