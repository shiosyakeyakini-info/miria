import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/federation_data.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/federation_page/federation_ads.dart";
import "package:miria/view/federation_page/federation_announcements.dart";
import "package:miria/view/federation_page/federation_custom_emojis.dart";
import "package:miria/view/federation_page/federation_info.dart";
import "package:miria/view/federation_page/federation_timeline.dart";
import "package:miria/view/federation_page/federation_users.dart";
import "package:miria/view/search_page/note_search.dart";

@RoutePage()
class FederationPage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;
  final String host;

  const FederationPage({
    required this.accountContext,
    required this.host,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final federate = ref.watch(federationStateProvider(host));

    return switch (federate) {
      AsyncLoading() => Scaffold(
          appBar: AppBar(title: Text(host)),
          body: const Center(child: CircularProgressIndicator.adaptive()),
        ),
      AsyncError(:final error, :final stackTrace) => Scaffold(
          appBar: AppBar(title: Text(host)),
          body: ErrorDetail(error: error, stackTrace: stackTrace),
        ),
      AsyncData(:final value) => Builder(
          builder: (context) {
            final adsAvailable = value.ads.isNotEmpty;
            final isMisskey = value.isSupportedEmoji;
            final isAnotherHost = accountContext.postAccount.host != host;
            final isSupportedTimeline =
                isMisskey && value.isSupportedLocalTimeline;
            final enableLocalTimeline = isSupportedTimeline &&
                value.meta?.policies?.ltlAvailable == true;
            final enableSearch = isSupportedTimeline &&
                value.meta?.policies?.canSearchNotes == true;

            return DefaultTabController(
              length: 1 +
                  (isAnotherHost ? 1 : 0) +
                  (adsAvailable ? 1 : 0) +
                  (isMisskey ? 1 : 0) +
                  (isSupportedTimeline ? 1 : 0) +
                  (enableLocalTimeline ? 1 : 0) +
                  (enableSearch ? 1 : 0),
              child: Scaffold(
                appBar: AppBar(
                  title: Text(host),
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(text: S.of(context).serverInformation),
                      if (isAnotherHost) Tab(text: S.of(context).user),
                      if (adsAvailable) Tab(text: S.of(context).ad),
                      if (isMisskey) Tab(text: S.of(context).announcement),
                      if (isSupportedTimeline)
                        Tab(text: S.of(context).customEmoji),
                      if (isSupportedTimeline)
                        Tab(text: S.of(context).localTimelineAbbr),
                      if (enableSearch) Tab(text: S.of(context).search),
                    ],
                    tabAlignment: TabAlignment.center,
                  ),
                ),
                body: TabBarView(
                  children: [
                    FederationInfo(data: value),
                    if (isAnotherHost) FederationUsers(host: host),
                    if (adsAvailable) FederationAds(ads: [...value.ads]),
                    if (isMisskey)
                      AccountContextScope(
                        context: AccountContext(
                          getAccount: Account.demoAccount(host, value.meta),
                          postAccount: accountContext.postAccount,
                        ),
                        child: FederationAnnouncements(host: host),
                      ),
                    if (isSupportedTimeline)
                      AccountContextScope(
                        context: AccountContext(
                          getAccount: Account.demoAccount(host, value.meta),
                          postAccount: accountContext.postAccount,
                        ),
                        child: FederationCustomEmojis(
                          host: host,
                          meta: value.meta!,
                        ),
                      ),
                    if (isSupportedTimeline)
                      AccountContextScope(
                        context: AccountContext(
                          getAccount: Account.demoAccount(host, value.meta),
                          postAccount: accountContext.postAccount,
                        ),
                        child: FederationTimeline(
                          host: host,
                          meta: value.meta!,
                        ),
                      ),
                    if (enableSearch)
                      AccountContextScope(
                        context: AccountContext(
                          getAccount: Account.demoAccount(host, value.meta),
                          postAccount: accountContext.postAccount,
                        ),
                        child: NoteSearch(focusNode: FocusNode()),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
    };
  }
}
