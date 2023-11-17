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
              title: const Text("みつける"),
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: "ハイライト"),
                  Tab(text: "ユーザー"),
                  Tab(text: "ロール"),
                  Tab(text: "ページ"),
                  Tab(text: "Play"),
                  Tab(text: "ハッシュタグ"),
                  Tab(text: "よそのサーバー"),
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
