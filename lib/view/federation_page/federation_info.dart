import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/string_extensions.dart';
import 'package:miria/model/federation_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/constants.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:miria/view/federation_page/federation_page.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';

class FederationInfo extends ConsumerStatefulWidget {
  final String host;

  const FederationInfo({
    super.key,
    required this.host,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FederationInfoState();
}

class FederationInfoState extends ConsumerState<FederationInfo> {
  Object? error;
  FederationData? data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      try {
        final account = AccountScope.of(context);
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
                  name: metaResponse.name ?? "",
                  description: metaResponse.description ?? "",
                  usersCount: statsResponse.originalUsersCount,
                  notesCount: statsResponse.originalNotesCount,
                  reactionCount: statsResponse.reactionsCount,
                  softwareName: "misskey",
                  softwareVersion: metaResponse.version,
                  languages: metaResponse.langs,
                  ads: metaResponse.ads,

                  // 自分のサーバーが非対応ということはない
                  isSupportedAnnouncement: true,
                  isSupportedEmoji: true,
                  isSupportedLocalTimeline: true);
        } else {
          final federation = await ref
              .read(misskeyProvider(AccountScope.of(context)))
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

              final misskeyServer = Misskey(host: widget.host, token: null);
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
            } catch (e) {}
            ;
          }

          ref.read(federationPageFederationDataProvider.notifier).state =
              FederationData(
            bannerUrl: (misskeyMeta?.bannerUrl)?.toString(),
            faviconUrl: (federation.faviconUrl)?.toString(),
            tosUrl: (misskeyMeta?.tosUrl)?.toString(),
            name: misskeyMeta?.name ?? federation.name,
            description: misskeyMeta?.description ?? federation.description,
            usersCount: federation.usersCount,
            notesCount: federation.notesCount,
            softwareName: federation.softwareName ?? "",
            softwareVersion: federation.softwareVersion ?? "",
            languages: misskeyMeta?.langs ?? [],
            ads: misskeyMeta?.ads ?? [],
            isSupportedEmoji: isSupportedEmoji,
            isSupportedLocalTimeline: isSupportedLocalTimeline,
            isSupportedAnnouncement: isSupportedAnnouncement,
          );
        }

        setState(() {});
      } catch (e, s) {
        print(e);
        print(s);
        setState(() {
          error = e;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(federationPageFederationDataProvider);
    if (data != null) {
      final description = data.description.replaceAll(htmlTagRemove, "");
      return SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.bannerUrl != null)
                NetworkImageView(
                    url: data.bannerUrl!.toString(), type: ImageType.other),
              Row(
                children: [
                  if (data.faviconUrl != null)
                    SizedBox(
                      width: 32,
                      child: NetworkImageView(
                        url: data.faviconUrl!.toString(),
                        type: ImageType.serverIcon,
                      ),
                    ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      data.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Text(description),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        data.usersCount.format(ifNull: "???"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text(
                        "ユーザー",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        data.notesCount.format(ifNull: "???"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text(
                        "投稿",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      const Text(
                        "ソフトウェア",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${data.softwareName} ${data.softwareVersion}",
                      )
                    ],
                  ),
                  if (data.languages.isNotEmpty)
                    TableRow(children: [
                      const Text("言語", textAlign: TextAlign.center),
                      Text(
                        data.languages.join(", "),
                      )
                    ]),
                  if (data.tosUrl != null)
                    TableRow(children: [
                      const Text(
                        "利用規約",
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse(data.tosUrl!)),
                        child: Text(
                          data.tosUrl!.toString().tight,
                          style: AppTheme.of(context).linkStyle,
                        ),
                      )
                    ])
                ],
              ),
            ],
          ),
        ),
      );
    }
    if (error != null) {
      ErrorDetail(error: error);
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
