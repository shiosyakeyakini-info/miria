import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/note_visibility_extension.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/common/misskey_notes/misskey_note_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/misskey_notes/local_only_icon.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
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
      await ref.read(misskeyProvider(this.account)).notes.create(
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
      await ref.read(misskeyProvider(this.account)).notes.create(
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
      await ref.read(misskeyProvider(this.account)).notes.create(
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
              .read(misskeyProvider(this.account))
              .channels
              .show(ChannelsShowRequest(channelId: channelId)),
        );
  }
}

@Riverpod(dependencies: [accountContext], keepAlive: false)
class RenoteOtherAccountNotifier extends _$RenoteOtherAccountNotifier {
  @override
  AsyncValue<(Account, Note)>? build(Account account, Note note) => null;

  Future<void> renoteOtherAccount() async {
    final selectedAccount = await ref.read(appRouterProvider).push<Account>(
          AccountSelectRoute(
            host: note.localOnly ? this.account.host : null,
            remoteHost:
                note.user.host != this.account.host && note.user.host != null
                    ? note.user.host
                    : null,
          ),
        );
    if (selectedAccount == null) return;
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      final accountContext = AccountContext(
        getAccount: selectedAccount,
        postAccount: selectedAccount.isDemoAccount
            ? ref.read(accountContextProvider).postAccount
            : selectedAccount,
      );
      state = const AsyncLoading();
      final foundNote = note.user.host == null &&
              note.uri?.host == accountContext.getAccount.host
          ? note
          : await ref
              .read(misskeyNoteNotifierProvider.notifier)
              .lookupNote(note: note, accountContext: accountContext);
      if (foundNote == null) {
        state = null;
        return;
      }
      ref.read(notesProvider(selectedAccount)).registerNote(foundNote);
      state = AsyncValue.data((selectedAccount, foundNote));
    });
  }
}

@RoutePage()
class RenoteModalSheet extends HookConsumerWidget implements AutoRouteWrapper {
  final Note note;
  final Account account;

  const RenoteModalSheet({
    required this.note,
    required this.account,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) => AccountContextScope.as(
        account: account,
        child: this,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channel = note.channel;
    final notifier = renoteNotifierProvider(account, note).notifier;

    ref
      ..listen(renoteNotifierProvider(account, note), (_, next) {
        if (next is! AsyncData) return;
        unawaited(context.maybePop());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).renoted),
            duration: const Duration(seconds: 1),
          ),
        );
      })
      ..listen(renoteChannelNotifierProvider(account), (_, next) async {
        if (next is! AsyncData || next == null) return;
        unawaited(context.maybePop());
        await context.pushRoute(
          NoteCreateRoute(
            renote: note,
            channel: next.value,
            initialAccount: account,
          ),
        );
      })
      ..listen(renoteOtherAccountNotifierProvider(account, note),
          (_, next) async {
        if (next is! AsyncData<(Account, Note)>) return;
        unawaited(context.maybePop());
        await context.pushRoute(
          RenoteModalRoute(
            account: next.value.$1,
            note: next.value.$2,
          ),
        );
      });

    final renoteState = ref.watch(renoteNotifierProvider(account, note));
    final renoteChannelState =
        ref.watch(renoteChannelNotifierProvider(account));

    final renoteOtherAccountState =
        ref.watch(renoteOtherAccountNotifierProvider(account, note));

    final isLocalOnly = useState(false);
    final visibility = useState(NoteVisibility.public);
    useEffect(
      () {
        final accountSettings =
            ref.read(accountSettingsRepositoryProvider).fromAccount(account);
        isLocalOnly.value = accountSettings.defaultIsLocalOnly;
        visibility.value =
            accountSettings.defaultNoteVisibility == NoteVisibility.specified
                ? NoteVisibility.followers
                : accountSettings.defaultNoteVisibility;
        return null;
      },
      const [],
    );

    if (renoteState is AsyncLoading ||
        renoteChannelState is AsyncLoading ||
        renoteOtherAccountState is AsyncLoading ||
        renoteState is AsyncData ||
        renoteChannelState is AsyncData ||
        renoteOtherAccountState is AsyncData) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    return ListView(
      children: [
        ListTile(
          leading: AvatarIcon(user: account.i),
          title: SimpleMfmText(
            account.i.name ?? account.i.username,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            account.acct.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: IconButton(
            onPressed: () async => await ref
                .read(
                  renoteOtherAccountNotifierProvider(account, note).notifier,
                )
                .renoteOtherAccount(),
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ),
        Divider(color: Theme.of(context).primaryColor, thickness: 2),
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
                  .read(renoteChannelNotifierProvider(account).notifier)
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
        if (note.channel?.allowRenoteToExternal != false) ...[
          ListTile(
            onTap: () async =>
                ref.read(notifier).renote(isLocalOnly.value, visibility.value),
            leading: const Icon(Icons.repeat),
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(S.of(context).renote),
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
                    value: visibility.value,
                    onChanged: (value) =>
                        visibility.value = value ?? NoteVisibility.public,
                  ),
                ),
                IconButton(
                  onPressed: () => isLocalOnly.value = !isLocalOnly.value,
                  icon: isLocalOnly.value
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
                NoteCreateRoute(renote: note, initialAccount: account),
              );
            },
            leading: const Icon(Icons.format_quote),
            title: Text(S.of(context).quotedRenote),
          ),
          ListTile(
            onTap: () async {
              final selected = await context.pushRoute<CommunityChannel>(
                ChannelSelectRoute(account: account),
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
              note.channel != null
                  ? S.of(context).renoteInOtherChannel
                  : S.of(context).renoteInChannel,
            ),
          ),
          ListTile(
            onTap: () async {
              final selected = await context.pushRoute<CommunityChannel>(
                ChannelSelectRoute(account: account),
              );
              if (!context.mounted) return;
              if (selected == null) return;
              await context.maybePop();
              if (!context.mounted) return;
              await context.pushRoute(
                NoteCreateRoute(
                  renote: note,
                  initialAccount: account,
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
              note.channel != null
                  ? S.of(context).quotedRenoteInOtherChannel
                  : S.of(context).quotedRenoteInChannel,
            ),
          ),
        ],
      ],
    );
  }
}
