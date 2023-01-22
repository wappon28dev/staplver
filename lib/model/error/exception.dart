import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../repository/assets.dart';
import '../../repository/config.dart';
import '../../view/util/route.dart';
import '../../vm/page.dart';
import '../../vm/theme.dart';
import '../class/app.dart';
import '../constant.dart';
import '../helper/config.dart';

class AIBASExceptions {
  AIBASException svnExecNotFound(SvnExecs svnExecs) => AIBASException(
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
              final pageNotifier = ref.read(pageProvider.notifier);
              await pageNotifier.resetProgress();
              pageNotifier.updateProgress(0.3);
              await launchUrl(gitHubReleaseUrl);
              await pageNotifier.completeProgress();
            },
          ),
        ],
      );

  AIBASException workingDirNotFound() => const AIBASException(
        message: '作業フォルダーが見つかりません',
        icon: Icons.search_off,
      );
  AIBASException backupDirNotFound() => const AIBASException(
        message: 'バックアップフォルダーが見つかりません',
        icon: Icons.search_off,
      );

  AIBASException backupDirNotFoundOnLoad(
    String backupDirStr,
    String workingDirStr,
  ) =>
      AIBASException(
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
              final pageNotifier = ref.read(pageProvider.notifier);

              await pageNotifier.resetProgress();
              pageNotifier.updateProgress(0.3);
              await AppConfigRepository().removeSavedProject(backupDirStr);
              await pageNotifier.completeProgress();

              RouteController.runPush(
                context: context,
                page: const AIBAS(),
                isReplace: true,
              );
            },
          ),
        ],
      );

  AIBASException workingDirNotFoundOnLoad(
    String backupDirStr,
    String workingDirStr,
  ) =>
      AIBASException(
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
              final pageNotifier = ref.read(pageProvider.notifier);

              await pageNotifier.resetProgress();
              pageNotifier.updateProgress(0.3);
              await AppConfigRepository().removeSavedProject(backupDirStr);
              await pageNotifier.completeProgress();

              RouteController.runPush(
                context: context,
                page: const AIBAS(),
                isReplace: true,
              );
            },
          ),
        ],
      );

  AIBASException pjNameIsInvalid() => const AIBASException(
        message: 'プロジェクト名が不正です',
      );
  AIBASException backupMinIsInvalid() => const AIBASException(
        message: 'バックアップ頻度が不正です',
      );
  AIBASException pjConfigIsNull() => const AIBASException(
        message: 'プロジェクトの設定ファイルに問題があるようです',
      );
  AIBASException appConfigIsInvalid() => AIBASException(
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
                page: const AIBAS(),
                isReplace: true,
              );
            },
          ),
        ],
      );
  AIBASException appConfigNotFound() =>
      const AIBASException(message: 'アプリの設定ファイルが見つかりません');

  AIBASException appConfigCannotLoaded(
    String? osMessage,
  ) {
    return AIBASException(
      message: osMessage == null
          ? 'アプリの設定ファイルは次の理由で読み込めませんでした:\n$osMessage'
          : '不明な理由で, アプリの設定ファイルを読み込めません',
    );
  }

  AIBASException pjConfigThemeModeIsInvalid() => AIBASException(
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
              final pageNotifier = ref.read(pageProvider.notifier);
              final themeNotifier = ref.read(themeProvider.notifier);

              await pageNotifier.resetProgress();
              pageNotifier.updateProgress(0.3);
              themeNotifier.updateThemeMode(ThemeMode.system);
              await AppConfigHelper().updateAppConfig(ref);
              await pageNotifier.completeProgress();

              RouteController.runPush(
                context: context,
                page: const AIBAS(),
                isReplace: true,
              );
            },
          ),
        ],
      );
  AIBASException pjNotFound() => const AIBASException(
        message: 'バックアップフォルダーはSVNリポジトリですが, AIBASプロジェクトではありません',
      );
  AIBASException pjAlreadyExists() => const AIBASException(
        message: 'AIBASプロジェクトは既に存在します',
      );
  AIBASException dirAlreadySVNRepo() => const AIBASException(
        message: 'SVNリポジトリは既に存在します',
      );
  AIBASException dirNotSVNRepo() => const AIBASException(
        message: 'SVNリポジトリではありません',
      );
  AIBASException importedPjIsNull() => const AIBASException(
        message: 'インポートしたプロジェクトに問題があるようです',
      );

  AIBASException svnRepositoryInfoIsInvalid() => const AIBASException(
        message: 'SVNリポジトリログのXMLが不正です',
      );
  AIBASException svnRevisionLogIsInvalid() => const AIBASException(
        message: 'SVNログのXMLが不正です',
      );
  AIBASException svnStatusIsInvalid() => const AIBASException(
        message: 'SVNステータスのXMLが不正です',
      );
}
