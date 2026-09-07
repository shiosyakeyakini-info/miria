import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:url_launcher/url_launcher.dart";

class LinkNavigator {
  const LinkNavigator();

  /// URLを扱えるアプリがあればそれで、なければ外部ブラウザで開く。
  ///
  /// 失敗の伝え方がプラットフォームによって違う。Androidは
  /// PlatformExceptionを投げるが、iOSは
  /// UIApplication.open(universalLinksOnly:) がfalseを返すだけで例外を
  /// 投げない。例外だけを見ていると、ふつうのWebサイトはUniversal Linkを
  /// 持つアプリがないのでiOSでは何も起きなくなる。戻り値と例外の両方を見る。
  Future<void> _launchExternal(Uri uri) async {
    bool launched;
    try {
      launched = await launchUrl(
        uri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } catch (_) {
      launched = false;
    }
    if (!launched) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> onTapLink(
    BuildContext context,
    WidgetRef ref,
    String url,
    String? host,
  ) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return; //TODO: なおす
    }
    var accountContext = ref.read(accountContextProvider);

    // 他サーバーや外部サイトは別アプリで起動する
    if (uri.host != accountContext.getAccount.host) {
      try {
        // nodeinfo は見ない。連合をオフにしたサーバーは 403 を返すため、
        // ここで弾くと Misskey なのに外部ブラウザに飛んでしまう (#770)。
        // Misskey かどうかは下の endpoints() で判定できる。
        final meta = await ref
            .read(misskeyWithoutAccountProvider(uri.host))
            .meta();
        final endpoints = await ref
            .read(misskeyWithoutAccountProvider(uri.host))
            .endpoints();
        if (!endpoints.contains("emojis")) {
          throw Exception("Is not misskey");
        }
        final account = Account.demoAccount(uri.host, meta);
        accountContext = accountContext.copyWith(getAccount: account);
        await ref.read(emojiRepositoryProvider(account)).loadFromSourceIfNeed();
      } catch (e) {
        if (await canLaunchUrl(uri)) {
          await _launchExternal(uri);
          return;
        }
      }
    }

    if (!context.mounted) return;
    if (uri.pathSegments.isEmpty) {
      await context.pushRoute(
        FederationRoute(accountContext: accountContext, host: uri.host),
      );
    } else if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == "clips") {
      // クリップはクリップの画面で開く
      await context.pushRoute(
        ClipDetailRoute(
          accountContext: accountContext,
          id: uri.pathSegments[1],
        ),
      );
    } else if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == "channels") {
      await context.pushRoute(
        ChannelDetailRoute(
          accountContext: accountContext,
          channelId: uri.pathSegments[1],
        ),
      );
    } else if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == "notes") {
      final note = await ref
          .read(misskeyProvider(accountContext.getAccount))
          .notes
          .show(NotesShowRequest(noteId: uri.pathSegments[1]));
      if (!context.mounted) return;
      await context.pushRoute(
        NoteDetailRoute(accountContext: accountContext, note: note),
      );
    } else if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == "announcements") {
      //TODO: とりあえずはこれでゆるして
      await context.pushRoute(
        FederationRoute(accountContext: accountContext, host: uri.host),
      );
    } else if (uri.pathSegments.length == 3 && uri.pathSegments[1] == "pages") {
      final page = await ref
          .read(misskeyProvider(accountContext.getAccount))
          .pages
          .show(
            PagesShowRequest(
              name: uri.pathSegments[2],
              username: uri.pathSegments[0].substring(1),
            ),
          );
      if (!context.mounted) return;
      await context.pushRoute(
        MisskeyRouteRoute(accountContext: accountContext, page: page),
      );
    } else if (uri.pathSegments.length == 1 &&
        uri.pathSegments.first.startsWith("@")) {
      final userName = ("@".allMatches(uri.pathSegments.first).length == 1)
          ? "${uri.pathSegments.first}@${uri.host}"
          : uri.pathSegments.first;

      await onMentionTap(context, ref, userName, host);
    } else {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> onMentionTap(
    BuildContext context,
    WidgetRef ref,
    String userName,
    String? host,
  ) async {
    // 自分のインスタンスの誰か
    // 本当は向こうで呼べばいいのでいらないのだけど
    final regResult = RegExp(r"^@?(.+?)(@(.+?))?$").firstMatch(userName);
    final accountContext = ref.read(accountContextProvider);
    final contextHost = accountContext.getAccount.host;
    final noteHost = host ?? accountContext.getAccount.host;
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
        .read(misskeyProvider(accountContext.getAccount))
        .users
        .show(
          UsersShowRequest(
            username: regResult?.group(1) ?? "",
            host: finalHost,
          ),
        );

    if (!context.mounted) return;
    await context.pushRoute(
      UserRoute(userId: response.id, accountContext: accountContext),
    );
  }
}
