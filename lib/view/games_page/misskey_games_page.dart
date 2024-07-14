import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:url_launcher/url_launcher_string.dart";

part "misskey_games_page.g.dart";

@RoutePage()
class MisskeyGamesPage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const MisskeyGamesPage({required this.accountContext, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).misskeyGames),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(S.of(context).cookieCliker),
            onTap: () async => launchUrlString(
              "https://${accountContext.postAccount.host}/clicker",
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            title: Text(S.of(context).bubbleGame),
            onTap: () async => launchUrlString(
              "https://${accountContext.postAccount.host}/bubble-game",
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            title: Text(S.of(context).reversi),
            subtitle: const ReversiInvite(),
            onTap: () async => launchUrlString(
              "https://${accountContext.postAccount.host}/reversi",
              mode: LaunchMode.externalApplication,
            ),
          ),
        ],
      ),
    );
  }
}

@Riverpod(dependencies: [misskeyPostContext])
Future<List<User>> _fetchReversiData(
  _FetchReversiDataRef ref,
) async {
  return [...await ref.read(misskeyPostContextProvider).reversi.invitations()];
}

class ReversiInvite extends ConsumerWidget {
  const ReversiInvite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reversiInvitation = ref.watch(_fetchReversiDataProvider);

    return switch (reversiInvitation) {
      AsyncLoading() => Text(S.of(context).loading),
      AsyncData<List<User>>(:final value) => value.isEmpty
          ? Text(S.of(context).nonInvitedReversi)
          : Text(
              S.of(context).invitedReversi(
                    value.map((e) => e.name ?? e.username).join(", "),
                  ),
            ),
      AsyncError() => const SizedBox.shrink(),
    };
  }
}
