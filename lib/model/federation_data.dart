import "dart:async";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/log.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "federation_data.freezed.dart";
part "federation_data.g.dart";

@freezed
class FederationData with _$FederationData {
  const factory FederationData({
    required bool isSupportedEmoji,
    required bool isSupportedAnnouncement,
    required bool isSupportedLocalTimeline,
    String? bannerUrl,
    String? faviconUrl,
    String? tosUrl,
    String? privacyPolicyUrl,
    String? impressumUrl,
    String? repositoryUrl,
    @Default([]) List<String> serverRules,
    @Default("") String name,
    @Default("") String description,
    String? maintainerName,
    String? maintainerEmail,
    int? usersCount,
    int? notesCount,
    int? reactionCount,
    @Default("") String softwareName,
    @Default("") String softwareVersion,
    @Default([]) List<String> languages,
    @Default([]) List<MetaAd> ads,
    MetaResponse? meta,
  }) = _FederationData;
}

@Riverpod(dependencies: [accountContext, misskeyGetContext])
class FederationState extends _$FederationState {
  @override
  Future<FederationData> build(String host) async {
    if (host == ref.read(accountContextProvider).getAccount.host) {
      // 自分のサーバーの場合
      final metaResponse = await ref.read(misskeyGetContextProvider).meta();

      // api/statsはリアクション数が十分多いサーバーでエラーを吐くことがある
      StatsResponse? statsResponse;
      try {
        statsResponse = await ref.read(misskeyGetContextProvider).stats();
      } catch (e) {
        logger.warning(e);
      }

      unawaited(
        ref
            .read(
              emojiRepositoryProvider(Account.demoAccount(host, metaResponse)),
            )
            .loadFromSourceIfNeed(),
      );
      return FederationData(
        bannerUrl: metaResponse.bannerUrl?.toString(),
        faviconUrl: metaResponse.iconUrl?.toString(),
        tosUrl: metaResponse.tosUrl?.toString(),
        privacyPolicyUrl: metaResponse.privacyPolicyUrl?.toString(),
        impressumUrl: metaResponse.impressumUrl?.toString(),
        repositoryUrl: metaResponse.repositoryUrl.toString(),
        name: metaResponse.name ?? "",
        description: metaResponse.description ?? "",
        usersCount: statsResponse?.originalUsersCount,
        notesCount: statsResponse?.originalNotesCount,
        maintainerName: metaResponse.maintainerName,
        maintainerEmail: metaResponse.maintainerEmail,
        serverRules: metaResponse.serverRules,
        reactionCount: statsResponse?.reactionsCount,
        softwareName: "misskey",
        softwareVersion: metaResponse.version,
        languages: metaResponse.langs,
        ads: metaResponse.ads,
        meta: metaResponse,

        // 自分のサーバーが非対応ということはない
        isSupportedAnnouncement: true,
        isSupportedEmoji: true,
        isSupportedLocalTimeline: true,
      );
    }
    final federation = await ref
        .read(misskeyGetContextProvider)
        .federation
        .showInstance(FederationShowInstanceRequest(host: host));

    final federateData = FederationData(
      faviconUrl: federation.faviconUrl?.toString(),
      isSupportedEmoji: false,
      isSupportedAnnouncement: false,
      isSupportedLocalTimeline: false,
      name: federation.name,
      usersCount: federation.usersCount,
      notesCount: federation.notesCount,
      softwareName: federation.softwareName ?? "",
    );
    state = AsyncData(federateData);

    MetaResponse? misskeyMeta;
    var isSupportedEmoji = false;
    var isSupportedAnnouncement = false;
    var isSupportedLocalTimeline = false;

    if (federation.softwareName == "fedibird" ||
        federation.softwareName == "mastodon") {
      // already known unsupported software.
    } else {
      // Misskeyサーバーかもしれなかったら追加の情報を取得

      try {
        final misskeyServer = ref.read(misskeyWithoutAccountProvider(host));
        final (endpoints, meta) =
            await (misskeyServer.endpoints(), misskeyServer.meta()).wait;
        misskeyMeta = meta;

        if (endpoints.contains("announcement")) {
          isSupportedAnnouncement = true;
        }

        // 絵文字が取得できなければローカルタイムラインを含め非対応
        if (endpoints.contains("emojis")) {
          isSupportedEmoji = true;

          if (endpoints.contains("notes/local-timeline")) {
            isSupportedLocalTimeline = true;
          }

          unawaited(
            ref
                .read(
                  emojiRepositoryProvider(
                    Account.demoAccount(host, misskeyMeta),
                  ),
                )
                .loadFromSourceIfNeed(),
          );
        }
      } catch (e) {
        logger.warning(e);
      }
    }

    return FederationData(
      bannerUrl: misskeyMeta?.bannerUrl?.toString(),
      tosUrl: misskeyMeta?.tosUrl?.toString(),
      privacyPolicyUrl: misskeyMeta?.privacyPolicyUrl?.toString(),
      impressumUrl: misskeyMeta?.impressumUrl?.toString(),
      repositoryUrl: misskeyMeta?.repositoryUrl?.toString(),
      name: misskeyMeta?.name ?? federation.name,
      description: misskeyMeta?.description ?? federation.description ?? "",
      maintainerName: misskeyMeta?.maintainerName,
      maintainerEmail: misskeyMeta?.maintainerEmail,
      softwareVersion: misskeyMeta?.version ?? federation.softwareVersion ?? "",
      languages: misskeyMeta?.langs ?? [],
      ads: misskeyMeta?.ads ?? [],
      serverRules: misskeyMeta?.serverRules ?? [],
      isSupportedEmoji: isSupportedEmoji,
      isSupportedLocalTimeline: isSupportedLocalTimeline,
      isSupportedAnnouncement: isSupportedAnnouncement,
      softwareName: federation.softwareName ?? "",
      usersCount: federation.usersCount,
      notesCount: federation.notesCount,
      meta: misskeyMeta,
    );
  }
}
