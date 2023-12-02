import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/federation_data.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/federation_page/federation_ads.dart';
import 'package:miria/view/federation_page/federation_announcements.dart';
import 'package:miria/view/federation_page/federation_custom_emojis.dart';
import 'package:miria/view/federation_page/federation_info.dart';
import 'package:miria/view/federation_page/federation_timeline.dart';
import 'package:miria/view/federation_page/federation_users.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  Widget build(BuildContext context) {
    final metaResponse = ref.watch(federationPageFederationDataProvider);
    final adsAvailable = metaResponse?.ads.isNotEmpty == true;
    final isMisskey = metaResponse?.isSupportedEmoji == true;
    final isAnotherHost = widget.account.host != widget.host;
    final isSupportedTimeline =
        isMisskey && metaResponse?.isSupportedLocalTimeline == true;
    return AccountScope(
      account: widget.account,
      child: DefaultTabController(
        length: 1 +
            (isAnotherHost ? 1 : 0) +
            (adsAvailable ? 1 : 0) +
            (isMisskey ? 1 : 0) +
            (isSupportedTimeline ? 2 : 0),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.host),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: S.of(context).serverInformation),
                if (isAnotherHost) Tab(text: S.of(context).user),
                if (adsAvailable) Tab(text: S.of(context).ad),
                if (isMisskey) Tab(text: S.of(context).announcement),
                if (isSupportedTimeline) Tab(text: S.of(context).customEmoji),
                if (isSupportedTimeline)
                  Tab(text: S.of(context).localTimelineAbbr)
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
                FederationCustomEmojis(host: widget.host),
              if (isSupportedTimeline) FederationTimeline(host: widget.host),
            ],
          ),
        ),
      ),
    );
  }
}
