import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/search_page/note_search.dart';
import 'package:miria/view/user_select_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

final noteSearchProvider = StateProvider.autoDispose((ref) => "");
final noteSearchUserProvider = StateProvider.autoDispose<User?>((ref) => null);
final noteSearchChannelProvider =
    StateProvider.autoDispose<CommunityChannel?>((ref) => null);

final noteSearchLocalOnlyProvider = StateProvider.autoDispose((ref) => false);

@RoutePage()
class SearchPage extends ConsumerStatefulWidget {
  final String? initialSearchText;
  final Account account;

  const SearchPage({
    super.key,
    this.initialSearchText,
    required this.account,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteSearchPageState();
}

class NoteSearchPageState extends ConsumerState<SearchPage> {
  late final List<FocusNode> focusNodes;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    focusNodes = [FocusNode(), FocusNode()];
  }

  @override
  void dispose() {
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AccountScope(
        account: widget.account,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("検索"),
            bottom: const TabBar(
              tabs: [
                Tab(text: "ノート"),
                Tab(text: "ユーザー"),
              ],
            ),
          ),
          body: Builder(
            builder: (context) {
              final tabController = DefaultTabController.of(context);
              tabController.addListener(() {
                if (tabController.index != tabIndex) {
                  focusNodes[tabController.index].requestFocus();
                  setState(() {
                    tabIndex = tabController.index;
                  });
                }
              });
              return TabBarView(
                controller: tabController,
                children: [
                  NoteSearch(
                    initialSearchText: widget.initialSearchText,
                    focusNode: focusNodes[0],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: UserSelectContent(
                      focusNode: focusNodes[1],
                      onSelected: (item) => context.pushRoute(
                        UserRoute(
                          user: item,
                          account: widget.account,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
