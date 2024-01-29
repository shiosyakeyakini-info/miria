import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

@RoutePage()
class MisskeyGamesPage extends ConsumerStatefulWidget {
  final Account account;

  const MisskeyGamesPage({super.key, required this.account});

  @override
  ConsumerState<MisskeyGamesPage> createState() => MisskeyGamesPageState();
}

class MisskeyGamesPageState extends ConsumerState<MisskeyGamesPage> {
  bool isLoaded = false;
  List<User> reversiInvitations = [];
  List<User> reversiWaiting = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      reversiInvitations = (await ref
              .read(misskeyProvider(widget.account))
              .reversi
              .invitations())
          .toList();

      setState(() {
        isLoaded = true;
      });
    });
  }

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
            onTap: () => launchUrlString(
              "https://${widget.account.host}/clicker",
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            title: Text(S.of(context).bubbleGame),
            onTap: () => launchUrlString(
              "https://${widget.account.host}/bubble-game",
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            title: Text(S.of(context).reversi),
            subtitle: !isLoaded
                ? Text(S.of(context).loading)
                : reversiInvitations.isEmpty
                    ? Text(S.of(context).nonInvitedReversi)
                    : Text(
                        S.of(context).invitedReversi(
                              reversiInvitations
                                  .map((e) => e.name ?? e.username)
                                  .join(", "),
                            ),
                      ),
            onTap: () => launchUrlString(
              "https://${widget.account.host}/reversi",
              mode: LaunchMode.externalApplication,
            ),
          )
        ],
      ),
    );
  }
}
