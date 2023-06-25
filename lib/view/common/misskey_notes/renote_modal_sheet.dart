import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/settings_page/tab_settings_page/channel_select_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

class RenoteModalSheet extends ConsumerWidget {
  final Note note;
  final Account account;

  const RenoteModalSheet({
    super.key,
    required this.note,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        ListTile(
          onTap: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final navigator = Navigator.of(context);
            await ref
                .read(misskeyProvider(account))
                .notes
                .create(NotesCreateRequest(renoteId: note.id));
            scaffoldMessenger
                .showSnackBar(const SnackBar(content: Text("Renoteしました。")));
            navigator.pop();
          },
          title: const Text("Renote"),
        ),
        ListTile(
            onTap: () {
              final navigator = Navigator.of(context);
              context.pushRoute(
                  NoteCreateRoute(renote: note, initialAccount: account));
              navigator.pop();
            },
            title: const Text("引用Renote")),
        ListTile(
            onTap: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              final selected = await showDialog<CommunityChannel?>(
                  context: context,
                  builder: (context) => ChannelSelectDialog(account: account));
              if (selected != null) {
                await ref.read(misskeyProvider(account)).notes.create(
                    NotesCreateRequest(
                        renoteId: note.id, channelId: selected.id));

                scaffoldMessenger
                    .showSnackBar(const SnackBar(content: Text("Renoteしました。")));
                navigator.pop();
              }
            },
            title: const Text("チャンネルへRenote")),
        ListTile(
            onTap: () async {
              final navigator = Navigator.of(context);
              final selected = await showDialog<CommunityChannel?>(
                  context: context,
                  builder: (context) => ChannelSelectDialog(account: account));
              if (selected != null) {
                context.pushRoute(NoteCreateRoute(
                    renote: note, initialAccount: account, channel: selected));
                navigator.pop();
              }
            },
            title: const Text("チャンネルへ引用Renote")),
      ],
    );
  }
}
