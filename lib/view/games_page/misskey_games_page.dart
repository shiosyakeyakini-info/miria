import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:url_launcher/url_launcher_string.dart";

part "misskey_games_page.g.dart";

@RoutePage()
class MisskeyGamesPage extends ConsumerStatefulWidget {
  final Account account;

  const MisskeyGamesPage({required this.account, super.key});

  @override
  ConsumerState<MisskeyGamesPage> createState() => MisskeyGamesPageState();
}

class MisskeyGamesPageState extends ConsumerState<MisskeyGamesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).misskeyGames),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(S.of(context).cookieCliker),
            onTap: () async => launchUrlString(
              "https://${widget.account.host}/clicker",
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            title: Text(S.of(context).bubbleGame),
            onTap: () async => launchUrlString(
              "https://${widget.account.host}/bubble-game",
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            title: Text(S.of(context).reversi),
            subtitle: ReversiInvite(account: widget.account),
            onTap: () async => launchUrlString(
              "https://${widget.account.host}/reversi",
              mode: LaunchMode.externalApplication,
            ),
          ),
        ],
      ),
    );
  }
}

@riverpod
Future<List<User>> _fetchReversiData(
  _FetchReversiDataRef ref,
  Account account,
) async {
  return [...await ref.read(misskeyProvider(account)).reversi.invitations()];
}

class ReversiInvite extends ConsumerWidget {
  final Account account;

  const ReversiInvite({required this.account, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reversiInvitation = ref.watch(_fetchReversiDataProvider(account));

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
