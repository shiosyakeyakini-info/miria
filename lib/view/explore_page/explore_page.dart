import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/explore_page/explore_hashtags.dart';
import 'package:miria/view/explore_page/explore_highlight.dart';
import 'package:miria/view/explore_page/explore_pages.dart';
import 'package:miria/view/explore_page/explore_plays.dart';
import 'package:miria/view/explore_page/explore_role.dart';
import 'package:miria/view/explore_page/explore_server.dart';
import 'package:miria/view/explore_page/explore_users.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class ExplorePage extends ConsumerStatefulWidget {
  final Account account;

  const ExplorePage({
    super.key,
    required this.account,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ExplorePageState();
}

class ExplorePageState extends ConsumerState<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return AccountScope(
        account: widget.account,
        child: DefaultTabController(
          length: 7,
          child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).explore),
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: S.of(context).highlight),
                  Tab(text: S.of(context).user),
                  Tab(text: S.of(context).role),
                  Tab(text: S.of(context).page),
                  Tab(text: S.of(context).flash),
                  Tab(text: S.of(context).hashtag),
                  Tab(text: S.of(context).otherServers),
                ],
                tabAlignment: TabAlignment.center,
              ),
            ),
            body: const TabBarView(
              children: [
                ExploreHighlight(),
                ExploreUsers(),
                ExploreRole(),
                ExplorePages(),
                ExplorePlay(),
                ExploreHashtags(),
                ExploreServer(),
              ],
            ),
          ),
        ));
  }
}
