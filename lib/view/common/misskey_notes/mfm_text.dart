import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/app_theme.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/custom_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mfm_renderer/mfm_renderer.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';

class MfmText extends ConsumerStatefulWidget {
  final String mfmText;
  final String? host;
  final TextStyle? style;
  final Map<String, String> emoji;

  const MfmText(
    this.mfmText, {
    super.key,
    this.host,
    this.style,
    this.emoji = const {},
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MfmTextState();
}

class MfmTextState extends ConsumerState<MfmText> {
  Future<void> onTapLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return; //TODO: なおす
    }
    final account = AccountScope.of(context);

    // 他サーバーや外部サイトは別アプリで起動する
    if (uri.host != AccountScope.of(context).host) {
      if (await canLaunchUrl(uri)) {
        if (!await launchUrl(uri,
            mode: LaunchMode.externalNonBrowserApplication)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } else if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == "clips") {
      // クリップはクリップの画面で開く
      context.pushRoute(
          ClipDetailRoute(account: account, id: uri.pathSegments[1]));
    } else if (uri.pathSegments.length == 1 &&
        uri.pathSegments.first.startsWith("@")) {
      await onMentionTap(uri.pathSegments.first);
    } else {
      // 自サーバーは内部ブラウザで起動する
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    }
  }

  Future<void> onMentionTap(String userName) async {
    // 自分のインスタンスの誰か
    // 本当は向こうで呼べばいいのでいらないのだけど
    final regResult = RegExp(r'^@?(.+?)(@(.+?))?$').firstMatch(userName);

    final contextHost = AccountScope.of(context).host;
    final noteHost = widget.host ?? AccountScope.of(context).host;
    final regResultHost = regResult?.group(3);
    final String? finalHost;

    if (regResultHost == null && noteHost == contextHost) {
      // @なし
      finalHost = null;
    } else if (regResultHost == contextHost) {
      // @自分ドメイン
      finalHost = null;
    } else if (regResultHost != null) {
      finalHost = regResultHost;
    } else {
      finalHost = noteHost;
    }

    final response = await ref
        .read(misskeyProvider(AccountScope.of(context)))
        .users
        .showByName(UsersShowByUserNameRequest(
            userName: regResult?.group(1) ?? "", host: finalHost));

    if (!mounted) return;
    context.pushRoute(
        UserRoute(userId: response.id, account: AccountScope.of(context)));
  }

  void onHashtagTap(String hashtag) {
    context.pushRoute(
        HashtagRoute(account: AccountScope.of(context), hashtag: hashtag));
  }

  @override
  Widget build(BuildContext context) {
    return Mfm(
      widget.mfmText,
      emojiBuilder: (context, emojiName) => CustomEmoji.fromEmojiName(
        ":$emojiName:",
        ref.read(emojiRepositoryProvider(AccountScope.of(context))),
        anotherServerUrl: widget.emoji[emojiName],
        fontSizeRatio: 2,
      ),
      linkTap: onTapLink,
      linkStyle: AppTheme.of(context).linkStyle,
      mentionTap: (userName, host, acct) => onMentionTap(acct),
      hashtagTap: onHashtagTap,
      style: widget.style,
    );
  }
}

class SimpleMfmText extends ConsumerWidget {
  final String text;
  final TextStyle? style;
  final Map<String, String> emojis;

  const SimpleMfmText(
    this.text, {
    super.key,
    this.style,
    this.emojis = const {},
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleMfm(
      text,
      emojiBuilder: (context, emojiName) => CustomEmoji.fromEmojiName(
        ":$emojiName:",
        ref.read(emojiRepositoryProvider(AccountScope.of(context))),
        fontSizeRatio: 1,
        anotherServerUrl: emojis[emojiName],
      ),
      style: style,
    );
  }
}

class UserInformation extends ConsumerStatefulWidget {
  final User user;
  const UserInformation({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserInformationState();
}

class UserInformationState extends ConsumerState<UserInformation> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          SimpleMfmText(
            widget.user.name ?? widget.user.username,
            style: const TextStyle(fontWeight: FontWeight.bold),
            emojis: widget.user.emojis,
          ),
          for (final badge in widget.user.badgeRoles ?? [])
            Tooltip(
              message: badge.name,
              child: SizedBox(
                  height: MediaQuery.of(context).textScaleFactor *
                      (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 22),
                  child: Image.network(badge.iconUrl.toString())),
            )
        ]);
  }
}
