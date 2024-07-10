import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/note_search_condition.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/search_page/note_search.dart";
import "package:miria/view/user_select_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";

final noteSearchProvider = StateProvider.autoDispose((ref) => "");
final noteSearchUserProvider = StateProvider.autoDispose<User?>((ref) => null);
final noteSearchChannelProvider =
    StateProvider.autoDispose<CommunityChannel?>((ref) => null);

final noteSearchLocalOnlyProvider = StateProvider.autoDispose((ref) => false);

@RoutePage()
class SearchPage extends HookConsumerWidget implements AutoRouteWrapper {
  final NoteSearchCondition? initialNoteSearchCondition;
  final AccountContext accountContext;

  const SearchPage({
    required this.accountContext,
    super.key,
    this.initialNoteSearchCondition,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNodes = [useFocusNode(), useFocusNode()];
    final tabController = useTabController(initialLength: 2);
    final tabIndex = useState(0);
    tabController.addListener(() {
      if (tabController.index != tabIndex.value) {
        focusNodes[tabController.index].requestFocus();
        tabIndex.value = tabController.index;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).search),
        bottom: TabBar(
          tabs: [
            Tab(text: S.of(context).note),
            Tab(text: S.of(context).user),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          NoteSearch(
            initialCondition: initialNoteSearchCondition,
            focusNode: focusNodes[0],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: UserSelectContent(
              focusNode: focusNodes[1],
              isDetail: true,
              onSelected: (item) async => context.pushRoute(
                UserRoute(
                  userId: item.id,
                  accountContext: ref.read(accountContextProvider),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
