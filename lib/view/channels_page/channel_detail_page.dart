import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/common/misskey_notes/misskey_note_notifier.dart";
import "package:miria/view/channels_page/channel_detail_info.dart";
import "package:miria/view/channels_page/channel_timeline.dart";
import "package:miria/view/common/account_scope.dart";
import "package:riverpod_annotation/experimental/scope.dart";

@RoutePage()
@Dependencies([
  ChannelDetail,
  accountContext,
  misskeyPostContext,
  notesWith,
  MisskeyNoteNotifier,
  misskeyGetContext,
])
class ChannelDetailPage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;
  final String channelId;

  const ChannelDetailPage({
    required this.accountContext,
    required this.channelId,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).channel),
          bottom: TabBar(
            tabs: [
              Tab(child: Text(S.of(context).channelInformation)),
              Tab(child: Text(S.of(context).timeline)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ChannelDetailInfo(channelId: channelId),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ChannelTimeline(channelId: channelId),
            ),
          ],
        ),
        floatingActionButton: ref.read(accountContextProvider).isSame
            ? ChannelDetailFloatingActionButton(channelId: channelId)
            : null,
      ),
    );
  }
}

class ChannelDetailFloatingActionButton extends ConsumerWidget {
  final String channelId;

  const ChannelDetailFloatingActionButton({required this.channelId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelDetail = ref.watch(channelDetailProvider(channelId));
    return switch (channelDetail) {
      AsyncData(:final value) => FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () async {
          if (!context.mounted) return;
          await context.pushRoute(
            NoteCreateRoute(
              initialAccount: ref.read(accountContextProvider).postAccount,
              channel: value.channel,
            ),
          );
        },
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
