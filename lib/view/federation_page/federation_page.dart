import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/federation_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/federation_page/federation_ads.dart';
import 'package:miria/view/federation_page/federation_announcements.dart';
import 'package:miria/view/federation_page/federation_custom_emojis.dart';
import 'package:miria/view/federation_page/federation_info.dart';
import 'package:miria/view/federation_page/federation_timeline.dart';
import 'package:miria/view/federation_page/federation_users.dart';
import 'package:miria/view/search_page/note_search.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class FederationPage extends ConsumerStatefulWidget {
  final Account account;
  final String host;

  const FederationPage({
    super.key,
    required this.account,
    required this.host,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FederationPageState();
}

final federationPageFederationDataProvider =
    StateProvider.autoDispose<FederationData?>((ref) => null);

class FederationPageState extends ConsumerState<FederationPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      try {
        final account = widget.account;
        if (widget.host == account.host) {
          // 自分のサーバーの場合
          final metaResponse = await ref.read(misskeyProvider(account)).meta();
          final statsResponse =
              await ref.read(misskeyProvider(account)).stats();
          ref.read(federationPageFederationDataProvider.notifier).state =
              FederationData(
                  bannerUrl: metaResponse.bannerUrl?.toString(),
                  faviconUrl: metaResponse.iconUrl?.toString(),
                  tosUrl: metaResponse.tosUrl?.toString(),
                  privacyPolicyUrl: (metaResponse.privacyPolicyUrl)?.toString(),
                  impressumUrl: (metaResponse.impressumUrl)?.toString(),
                  repositoryUrl: (metaResponse.repositoryUrl).toString(),
                  name: metaResponse.name ?? "",
                  description: metaResponse.description ?? "",
                  usersCount: statsResponse.originalUsersCount,
                  notesCount: statsResponse.originalNotesCount,
                  maintainerName: metaResponse.maintainerName,
                  maintainerEmail: metaResponse.maintainerEmail,
                  serverRules: metaResponse.serverRules,
                  reactionCount: statsResponse.reactionsCount,
                  softwareName: "misskey",
                  softwareVersion: metaResponse.version,
                  languages: metaResponse.langs,
                  ads: metaResponse.ads,
                  meta: metaResponse,

                  // 自分のサーバーが非対応ということはない
                  isSupportedAnnouncement: true,
                  isSupportedEmoji: true,
                  isSupportedLocalTimeline: true);

          await ref
              .read(emojiRepositoryProvider(
                  Account.demoAccount(widget.host, metaResponse)))
              .loadFromSourceIfNeed();
        } else {
          final federation = await ref
              .read(misskeyProvider(widget.account))
              .federation
              .showInstance(FederationShowInstanceRequest(host: widget.host));
          MetaResponse? misskeyMeta;

          bool isSupportedEmoji = false;
          bool isSupportedAnnouncement = false;
          bool isSupportedLocalTimeline = false;

          if (federation.softwareName == "fedibird" ||
              federation.softwareName == "mastodon") {
            // already known unsupported software.
          } else {
            try {
              // Misskeyサーバーかもしれなかったら追加の情報を取得

              final misskeyServer =
                  ref.read(misskeyWithoutAccountProvider(widget.host));
              final endpoints = await misskeyServer.endpoints();

              if (endpoints.contains("announcement")) {
                isSupportedAnnouncement = true;
              }

              // 絵文字が取得できなければローカルタイムラインを含め非対応
              if (endpoints.contains("emojis")) {
                isSupportedEmoji = true;

                if (endpoints.contains("notes/local-timeline")) {
                  isSupportedLocalTimeline = true;
                }
              }

              misskeyMeta = await misskeyServer.meta();
              await ref
                  .read(emojiRepositoryProvider(
                      Account.demoAccount(widget.host, misskeyMeta)))
                  .loadFromSourceIfNeed();
            } catch (e) {}
            ;
          }

          ref.read(federationPageFederationDataProvider.notifier).state =
              FederationData(
            bannerUrl: (misskeyMeta?.bannerUrl)?.toString(),
            faviconUrl: (federation.faviconUrl)?.toString(),
            tosUrl: (misskeyMeta?.tosUrl)?.toString(),
            privacyPolicyUrl: (misskeyMeta?.privacyPolicyUrl)?.toString(),
            impressumUrl: (misskeyMeta?.impressumUrl)?.toString(),
            repositoryUrl: (misskeyMeta?.repositoryUrl)?.toString(),
            name: misskeyMeta?.name ?? federation.name,
            description: misskeyMeta?.description ?? federation.description,
            maintainerName: misskeyMeta?.maintainerName,
            maintainerEmail: misskeyMeta?.maintainerEmail,
            usersCount: federation.usersCount,
            notesCount: federation.notesCount,
            softwareName: federation.softwareName ?? "",
            softwareVersion:
                misskeyMeta?.version ?? federation.softwareVersion ?? "",
            languages: misskeyMeta?.langs ?? [],
            ads: misskeyMeta?.ads ?? [],
            serverRules: misskeyMeta?.serverRules ?? [],
            isSupportedEmoji: isSupportedEmoji,
            isSupportedLocalTimeline: isSupportedLocalTimeline,
            isSupportedAnnouncement: isSupportedAnnouncement,
            meta: misskeyMeta,
          );
        }

        if (!mounted) return;
        setState(() {});
      } catch (e, s) {
        print(e);
        print(s);
        if (!mounted) return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final metaResponse = ref.watch(federationPageFederationDataProvider);
    final adsAvailable = metaResponse?.ads.isNotEmpty == true;
    final isMisskey = metaResponse?.isSupportedEmoji == true;
    final isAnotherHost = widget.account.host != widget.host;
    final isSupportedTimeline =
        isMisskey && metaResponse?.isSupportedLocalTimeline == true;
    final enableLocalTimeline = isSupportedTimeline &&
        metaResponse?.meta?.policies?.ltlAvailable == true;
    final enableSearch = isSupportedTimeline &&
        metaResponse?.meta?.policies?.canSearchNotes == true;

    return AccountScope(
      account: widget.account,
      child: DefaultTabController(
        length: 1 +
            (isAnotherHost ? 1 : 0) +
            (adsAvailable ? 1 : 0) +
            (isMisskey ? 1 : 0) +
            (isSupportedTimeline ? 1 : 0) +
            (enableLocalTimeline ? 1 : 0) +
            (enableSearch ? 1 : 0),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.host),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                const Tab(text: "サーバー情報"),
                if (isAnotherHost) const Tab(text: "ユーザー"),
                if (adsAvailable) const Tab(text: "広告"),
                if (isMisskey) const Tab(text: "お知らせ"),
                if (isSupportedTimeline) const Tab(text: "カスタム絵文字"),
                if (enableLocalTimeline) const Tab(text: "LTL"),
                if (enableSearch) const Tab(text: "検索")
              ],
              tabAlignment: TabAlignment.center,
            ),
          ),
          body: TabBarView(
            children: [
              FederationInfo(host: widget.host),
              if (isAnotherHost) FederationUsers(host: widget.host),
              if (adsAvailable) const FederationAds(),
              if (isMisskey) FederationAnnouncements(host: widget.host),
              if (isSupportedTimeline)
                FederationCustomEmojis(
                    host: widget.host, meta: metaResponse!.meta!),
              if (isSupportedTimeline)
                FederationTimeline(
                    host: widget.host, meta: metaResponse!.meta!),
              if (enableSearch)
                AccountScope(
                    account:
                        Account.demoAccount(widget.host, metaResponse!.meta!),
                    child: NoteSearch(
                      focusNode: FocusNode(),
                      initialSearchText: "",
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
