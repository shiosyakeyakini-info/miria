import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/federation_data.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/federation_page/federation_ads.dart';
import 'package:miria/view/federation_page/federation_announcements.dart';
import 'package:miria/view/federation_page/federation_info.dart';
import 'package:miria/view/federation_page/federation_users.dart';
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
  Widget build(BuildContext context) {
    final metaResponse = ref.watch(federationPageFederationDataProvider);
    final adsAvailable = metaResponse?.ads.isNotEmpty == true;
    final isMisskey = metaResponse?.softwareName == "misskey";
    final isAnotherHost = widget.account.host != widget.host;
    return AccountScope(
      account: widget.account,
      child: DefaultTabController(
        length: 1 +
            (isAnotherHost ? 1 : 0) +
            (adsAvailable ? 1 : 0) +
            (isMisskey ? 1 : 0),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.host),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                const Tab(text: "サーバー情報"),
                if (isAnotherHost) const Tab(text: "ユーザー"),
                if (adsAvailable) const Tab(text: "広告"),
                if (isMisskey) const Tab(text: "お知らせ")
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FederationInfo(host: widget.host),
              if (isAnotherHost) FederationUsers(host: widget.host),
              if (adsAvailable) const FederationAds(),
              if (isMisskey) FederationAnnouncements(host: widget.host),
            ],
          ),
        ),
      ),
    );
  }
}
