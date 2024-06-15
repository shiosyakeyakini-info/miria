import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:miria/extensions/note_visibility_extension.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/misskey_notes/local_only_icon.dart";
import "package:miria/view/settings_page/tab_settings_page/channel_select_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "renote_modal_sheet.g.dart";

@Riverpod(keepAlive: false)
class RenoteNotifier extends _$RenoteNotifier {
  @override
  AsyncValue<void>? build(Account account, Note note) => null;

  /// チャンネル内にRenote
  Future<void> renoteInSpecificChannel() async {
    state = const AsyncLoading();
    state =
        await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await ref.read(misskeyProvider(account)).notes.create(
            NotesCreateRequest(
              renoteId: note.id,
              localOnly: true,
              channelId: note.channel!.id,
            ),
          );
    });
  }

  /// チャンネルにRenote
  Future<void> renoteInChannel(CommunityChannel channel) async {
    state = const AsyncLoading();
    state =
        await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await ref.read(misskeyProvider(account)).notes.create(
            NotesCreateRequest(
              renoteId: note.id,
              channelId: channel.id,
              localOnly: true,
            ),
          );
    });
  }

  /// 普通に引用Renote
  Future<void> renote(bool isLocalOnly, NoteVisibility visibility) async {
    state = const AsyncLoading();
    state =
        await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await ref.read(misskeyProvider(account)).notes.create(
            NotesCreateRequest(
              renoteId: note.id,
              localOnly: isLocalOnly,
              visibility: visibility,
            ),
          );
    });
  }
}

@Riverpod(keepAlive: false)
class RenoteChannelNotifier extends _$RenoteChannelNotifier {
  @override
  AsyncValue<CommunityChannel>? build(Account account) => null;

  /// Renoteの画面でチャンネル情報を取得する
  Future<void> findChannel(String channelId) async {
    state = const AsyncLoading();
    state = await ref.read(dialogStateNotifierProvider.notifier).guard(
          () async => await ref
              .read(misskeyProvider(account))
              .channels
              .show(ChannelsShowRequest(channelId: channelId)),
        );
  }
}

class RenoteModalSheet extends ConsumerStatefulWidget {
  final Note note;
  final Account account;

  const RenoteModalSheet({
    required this.note,
    required this.account,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      RenoteModalSheetState();
}

class RenoteModalSheetState extends ConsumerState<RenoteModalSheet> {
  bool isLocalOnly = false;
  var visibility = NoteVisibility.public;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final accountSettings =
        ref.read(accountSettingsRepositoryProvider).fromAccount(widget.account);
    isLocalOnly = accountSettings.defaultIsLocalOnly;
    visibility =
        accountSettings.defaultNoteVisibility == NoteVisibility.specified
            ? NoteVisibility.followers
            : accountSettings.defaultNoteVisibility;
  }

  @override
  Widget build(BuildContext context) {
    final channel = widget.note.channel;
    final notifier =
        renoteNotifierProvider(widget.account, widget.note).notifier;

    ref
      ..listen(renoteNotifierProvider(widget.account, widget.note), (_, next) {
        if (next is! AsyncData) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).renoted),
            duration: const Duration(seconds: 1),
          ),
        );
      })
      ..listen(renoteChannelNotifierProvider(widget.account), (_, next) async {
        if (next is! AsyncData || next == null) return;
        Navigator.of(context).pop();
        await context.pushRoute(
          NoteCreateRoute(
            renote: widget.note,
            channel: next.value,
            initialAccount: widget.account,
          ),
        );
      });

    final renoteState =
        ref.watch(renoteNotifierProvider(widget.account, widget.note));
    final renoteChannelState =
        ref.watch(renoteChannelNotifierProvider(widget.account));

    if (renoteState is AsyncLoading ||
        renoteChannelState is AsyncLoading ||
        renoteState is AsyncData ||
        renoteChannelState is AsyncData) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    return ListView(
      children: [
        if (channel != null) ...[
          ListTile(
            onTap: () async =>
                await ref.read(notifier).renoteInSpecificChannel(),
            leading: const SizedBox(
              height: 30,
              width: 30,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(Icons.monitor, size: 24),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.repeat, size: 18),
                  ),
                ],
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(S.of(context).renoteInSpecificChannel(channel.name)),
            ),
          ),
          ListTile(
            onTap: () async {
              await ref
                  .read(
                    renoteChannelNotifierProvider(widget.account).notifier,
                  )
                  .findChannel(channel.id);
            },
            leading: const SizedBox(
              height: 30,
              width: 30,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(Icons.monitor, size: 24),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.format_quote, size: 18),
                  ),
                ],
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                S.of(context).quotedRenoteInSpecificChannel(channel.name),
              ),
            ),
          ),
        ],
        if (widget.note.channel?.allowRenoteToExternal != false) ...[
          ListTile(
            onTap: () async =>
                ref.read(notifier).renote(isLocalOnly, visibility),
            leading: const Icon(Icons.repeat),
            title: const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text("Renote"),
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    items: [
                      for (final element in NoteVisibility.values.where(
                        (element) => element != NoteVisibility.specified,
                      ))
                        DropdownMenuItem(
                          value: element,
                          child: Text(element.displayName(context)),
                        ),
                    ],
                    value: visibility,
                    onChanged: (value) => setState(() {
                      visibility = value ?? NoteVisibility.public;
                    }),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    isLocalOnly = !isLocalOnly;
                  }),
                  icon: isLocalOnly
                      ? const LocalOnlyIcon()
                      : const Icon(Icons.rocket),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () async {
              Navigator.of(context).pop();
              await context.pushRoute(
                NoteCreateRoute(
                  renote: widget.note,
                  initialAccount: widget.account,
                ),
              );
            },
            leading: const Icon(Icons.format_quote),
            title: Text(S.of(context).quotedRenote),
          ),
          ListTile(
            onTap: () async {
              final selected = await showDialog<CommunityChannel?>(
                context: context,
                builder: (context) =>
                    ChannelSelectDialog(account: widget.account),
              );
              if (selected != null) {
                await ref.read(notifier).renoteInChannel(selected);
              }
            },
            leading: const SizedBox(
              height: 30,
              width: 30,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(Icons.monitor, size: 24),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.repeat, size: 18),
                  ),
                ],
              ),
            ),
            title: Text(
              widget.note.channel != null
                  ? S.of(context).renoteInOtherChannel
                  : S.of(context).renoteInChannel,
            ),
          ),
          ListTile(
            onTap: () async {
              final navigator = Navigator.of(context);
              final selected = await showDialog<CommunityChannel?>(
                context: context,
                builder: (context) =>
                    ChannelSelectDialog(account: widget.account),
              );
              if (!context.mounted) return;
              if (selected == null) return;
              navigator.pop();
              await context.pushRoute(
                NoteCreateRoute(
                  renote: widget.note,
                  initialAccount: widget.account,
                  channel: selected,
                ),
              );
            },
            leading: const SizedBox(
              height: 30,
              width: 30,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(Icons.monitor, size: 24),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.format_quote, size: 18),
                  ),
                ],
              ),
            ),
            title: Text(
              widget.note.channel != null
                  ? S.of(context).quotedRenoteInOtherChannel
                  : S.of(context).quotedRenoteInOtherChannel,
            ),
          ),
        ],
      ],
    );
  }
}
