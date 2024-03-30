import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkNavigator {
  const LinkNavigator();

  Future<void> onTapLink(
      BuildContext context, WidgetRef ref, String url, String? host) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return; //TODO: なおす
    }
    var account = AccountScope.of(context);

    // 他サーバーや外部サイトは別アプリで起動する
    if (uri.host != AccountScope.of(context).host) {
      try {
        await ref.read(dioProvider).getUri(Uri(
            scheme: "https",
            host: uri.host,
            pathSegments: [".well-known", "nodeinfo"]));
        final meta =
            await ref.read(misskeyWithoutAccountProvider(uri.host)).meta();
        final endpoints =
            await ref.read(misskeyWithoutAccountProvider(uri.host)).endpoints();
        if (!endpoints.contains("emojis")) {
          throw Exception("Is not misskey");
        }

        account = Account.demoAccount(uri.host, meta);
        await ref.read(emojiRepositoryProvider(account)).loadFromSourceIfNeed();
      } catch (e) {
        if (await canLaunchUrl(uri)) {
          if (!await launchUrl(uri,
              mode: LaunchMode.externalNonBrowserApplication)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          return;
        }
      }
    }

    if (uri.pathSegments.length == 2 && uri.pathSegments.first == "clips") {
      // クリップはクリップの画面で開く
      context.pushRoute(
          ClipDetailRoute(account: account, id: uri.pathSegments[1]));
    } else if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == "channels") {
      context.pushRoute(
          ChannelDetailRoute(account: account, channelId: uri.pathSegments[1]));
    } else if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == "notes") {
      final note = await ref
          .read(misskeyProvider(account))
          .notes
          .show(NotesShowRequest(noteId: uri.pathSegments[1]));
      context.pushRoute(NoteDetailRoute(account: account, note: note));
    } else if (uri.pathSegments.length == 3 && uri.pathSegments[1] == "pages") {
      final page = await ref.read(misskeyProvider(account)).pages.show(
          PagesShowRequest(
              name: uri.pathSegments[2],
              username: uri.pathSegments[0].substring(1)));
      context.pushRoute(MisskeyRouteRoute(account: account, page: page));
    } else if (uri.pathSegments.length == 1 &&
        uri.pathSegments.first.startsWith("@")) {
      await onMentionTap(context, ref, account, uri.pathSegments.first, host);
    } else {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> onMentionTap(BuildContext context, WidgetRef ref,
      Account account, String userName, String? host) async {
    // 自分のインスタンスの誰か
    // 本当は向こうで呼べばいいのでいらないのだけど
    final regResult = RegExp(r'^@?(.+?)(@(.+?))?$').firstMatch(userName);

    final contextHost = account.host;
    final noteHost = host ?? account.host;
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

    final response = await ref.read(misskeyProvider(account)).users.showByName(
        UsersShowByUserNameRequest(
            userName: regResult?.group(1) ?? "", host: finalHost));

    context.pushRoute(UserRoute(userId: response.id, account: account));
  }
}
