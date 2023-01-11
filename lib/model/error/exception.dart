// ignore_for_file: prefer_constructors_over_static_methods

import 'dart:io';

import 'package:aibas/main.dart';
import 'package:aibas/model/data/class.dart';
import 'package:aibas/repository/config.dart';
import 'package:aibas/view/util/route.dart';
import 'package:aibas/vm/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AIBASException implements Exception {
  const AIBASException({
    required this.message,
    this.actions,
    this.icon = Icons.error_outline,
    this.needShowAsBanner = false,
  });

  final String message;
  final IconData icon;
  final List<ExceptionAction>? actions;
  final bool needShowAsBanner;

  static const workingDirNotFound = AIBASException(
    message: '作業フォルダーが見つかりません',
    icon: Icons.search_off,
  );
  static const backupDirNotFound = AIBASException(
    message: 'バックアップフォルダーが見つかりません',
    icon: Icons.search_off,
  );

  static AIBASException backupDirNotFoundOnLoad(
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
          const ExceptionAction(
            title: '無視する',
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

  static AIBASException workingDirNotFoundOnLoad(
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
          const ExceptionAction(
            title: '無視する',
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

  static const pjNameIsInvalid = AIBASException(
    message: 'プロジェクト名が不正です',
  );
  static const backupMinIsInvalid = AIBASException(
    message: 'バックアップ頻度が不正です',
  );
  static const pjConfigIsNull = AIBASException(
    message: 'プロジェクトの設定ファイルに問題があるようです',
  );
  static final appConfigIsInvalid = AIBASException(
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
  static const appConfigNotFound = AIBASException(
    message: 'アプリの設定ファイルが見つかりません',
  );
  static AIBASException appConfigCannotLoaded(
    String? osMessage,
  ) {
    return AIBASException(
      message: osMessage == null
          ? 'アプリの設定ファイルは次の理由で読み込めませんでした:\n$osMessage'
          : '不明な理由で, アプリの設定ファイルを読み込めません',
    );
  }

  static const pjConfigThemeModeIsInvalid = AIBASException(
    message: 'アプリの設定ファイル内: ThemeModeが不正です',
  );
  static const pjNotFound = AIBASException(
    message: 'バックアップフォルダーはSVNリポジトリですが, AIBASプロジェクトではありません',
  );
  static const pjAlreadyExists = AIBASException(
    message: 'AIBASプロジェクトは既に存在します',
  );
  static const dirNotSVNRepo = AIBASException(
    message: 'SVNリポジトリではありません',
  );
  static const importedPjIsNull = AIBASException(
    message: 'インポートしたプロジェクトに問題があるようです',
  );
}
