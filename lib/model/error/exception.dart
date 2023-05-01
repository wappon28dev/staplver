// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../repository/assets.dart';
import '../../repository/config.dart';
import '../../view/util/route.dart';
import '../../vm/page.dart';
import '../../vm/projects.dart';
import '../../vm/theme.dart';
import '../class/app.dart';
import '../constant.dart';
import '../helper/config.dart';

class SystemExceptions {
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

  SystemException workingDirNotFound() => const SystemException(
        message: '作業フォルダーが見つかりません',
        icon: Icons.search_off,
      );
  SystemException backupDirNotFound() => const SystemException(
        message: 'バックアップフォルダーが見つかりません',
        icon: Icons.search_off,
      );

  SystemException backupDirNotFoundOnLoad(
    String backupDirStr,
    String workingDirStr,
  ) =>
      SystemException(
        message: '''
プロジェクトをロードしましたが, バックアップフォルダーが見つかりませんでした

バックアップフォルダー: $backupDirStr
作業フォルダー　　　　: $workingDirStr
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
              await AppConfigRepository().removeSavedProject(backupDirStr);
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

  SystemException workingDirNotFoundOnLoad(
    String backupDirStr,
    String workingDirStr,
  ) =>
      SystemException(
        message: '''
プロジェクトをロードしましたが, 作業フォルダーが見つかりませんでした

バックアップフォルダー: $backupDirStr
作業フォルダー　　　　: $workingDirStr
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
              await AppConfigRepository().removeSavedProject(backupDirStr);
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

  SystemException pjNameIsInvalid() => const SystemException(
        message: 'プロジェクト名が不正です',
      );
  SystemException backupMinIsInvalid() => const SystemException(
        message: 'バックアップ頻度が不正です',
      );
  SystemException pjConfigIsNull() => const SystemException(
        message: 'プロジェクトの設定ファイルに問題があるようです',
      );
  SystemException appConfigIsInvalid() => SystemException(
        message: 'アプリの設定ファイルが壊れています',
        needShowAsBanner: true,
        icon: Icons.broken_image,
        actions: [
          ExceptionAction(
            title: '設定フォルダーを開く',
            icon: Icons.folder_open,
            onClick: (BuildContext context, WidgetRef ref) async {
              final path = await AppConfigRepository().appConfigPath;
              await launchUrl(path.parent.uri);
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
  SystemException appConfigNotFound() =>
      const SystemException(message: 'アプリの設定ファイルが見つかりません');

  SystemException appConfigCannotLoaded(
    String? osMessage,
  ) {
    return SystemException(
      message: osMessage == null
          ? 'アプリの設定ファイルは次の理由で読み込めませんでした:\n$osMessage'
          : '不明な理由で, アプリの設定ファイルを読み込めません',
    );
  }

  SystemException pjConfigThemeModeIsInvalid() => SystemException(
        message: 'アプリの設定ファイル内: ThemeModeが不正です',
        needShowAsBanner: true,
        actions: [
          ExceptionAction(
            title: '無視する',
            onClick: (BuildContext context, WidgetRef ref) =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          ),
          ExceptionAction(
            title: '該当の設定を初期値に戻す',
            isPrimary: true,
            icon: Icons.delete_forever,
            onClick: (BuildContext context, WidgetRef ref) async {
              final pageNotifier = ref.read(pagePod.notifier);
              final themeNotifier = ref.read(appThemePod.notifier);

              await pageNotifier.resetProgress();
              pageNotifier.updateProgress(0.3);
              themeNotifier.updateThemeMode(ThemeMode.system);
              await AppConfigHelper().updateAppConfig(ref);
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

  SystemException pjConfigNotFound() =>
      const SystemException(message: 'プロジェクトの設定ファイルが見つかりません');

  SystemException pjConfigCannotLoaded(
    String? osMessage,
  ) {
    return SystemException(
      message: osMessage == null
          ? 'プロジェクトの設定ファイルは次の理由で読み込めませんでした:\n$osMessage'
          : '不明な理由で, アプリの設定ファイルを読み込めません',
    );
  }

  SystemException pjConfigIsInvalid() => SystemException(
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
          ExceptionAction(
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
          ),
        ],
      );

  SystemException pjNotFound() => const SystemException(
        message: 'バックアップフォルダーはSVNリポジトリですが, staplverプロジェクトではありません',
      );
  SystemException pjAlreadyExists() => const SystemException(
        message: 'staplverプロジェクトは既に存在します',
      );
  SystemException dirAlreadySVNRepo() => const SystemException(
        message: 'SVNリポジトリは既に存在します',
      );
  SystemException dirNotSVNRepo() => const SystemException(
        message: 'SVNリポジトリではありません',
      );
  SystemException importedPjIsNull() => const SystemException(
        message: 'インポートしたプロジェクトに問題があるようです',
      );

  SystemException svnRepositoryInfoIsInvalid() => const SystemException(
        message: 'SVNリポジトリログのXMLが不正です',
      );
  SystemException svnRevisionLogIsInvalid() => const SystemException(
        message: 'SVNログのXMLが不正です',
      );
  SystemException svnStatusIsInvalid() => const SystemException(
        message: 'SVNステータスのXMLが不正です',
      );
}
