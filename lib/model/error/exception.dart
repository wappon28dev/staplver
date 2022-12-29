// ignore_for_file: prefer_constructors_over_static_methods

import 'package:aibas/main.dart';
import 'package:aibas/repository/config.dart';
import 'package:aibas/view/util/transition.dart';
import 'package:aibas/vm/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIBASException implements Exception {
  const AIBASException({
    required this.message,
    this.icon = Icons.error_outline,
    this.approachLabel,
    this.approachIcon,
    this.onClick,
  });
  final String message;
  final IconData icon;
  final String? approachLabel;
  final IconData? approachIcon;
  final void Function(BuildContext context, WidgetRef ref)? onClick;

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
        approachIcon: Icons.delete_forever,
        approachLabel: '該当のプロジェクトをアプリの設定から削除する',
        onClick: (BuildContext context, WidgetRef ref) {
          ConfigController().removeSavedProject(backupDirStr);
          RouteController.runPush(
            context: context,
            page: const AIBAS(),
            isReplace: true,
          );
        },
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
        approachIcon: Icons.delete_forever,
        approachLabel: '該当のプロジェクトをアプリの設定から削除する',
        onClick: (BuildContext context, WidgetRef ref) async {
          final pageNotifier = ref.read(pageProvider.notifier);

          await pageNotifier.resetProgress();
          pageNotifier.updateProgress(0.3);
          await ConfigController().removeSavedProject(backupDirStr);
          await pageNotifier.completeProgress();

          RouteController.runPush(
            context: context,
            page: const AIBAS(),
            isReplace: true,
          );
        },
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
    icon: Icons.broken_image,
    approachIcon: Icons.restart_alt,
    approachLabel: '空の設定ファイルで上書きする',
    onClick: (BuildContext context, WidgetRef ref) {
      ConfigController().createEmptyAppConfig();
      RouteController.runPush(
        context: context,
        page: const AIBAS(),
        isReplace: true,
      );
    },
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
