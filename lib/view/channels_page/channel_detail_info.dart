import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/common/misskey_notes/misskey_note_notifier.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/experimental/mutation.dart";
import "package:riverpod_annotation/experimental/scope.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "channel_detail_info.freezed.dart";
part "channel_detail_info.g.dart";

@freezed
abstract class ChannelDetailState with _$ChannelDetailState {
  factory ChannelDetailState({required CommunityChannel channel}) =
      _ChannelDetailState;
}

@Riverpod(dependencies: [misskeyGetContext, misskeyPostContext, notesWith])
class ChannelDetail extends _$ChannelDetail {
  @override
  Future<ChannelDetailState> build(String channelId) async {
    final result = await ref
        .read(misskeyGetContextProvider)
        .channels
        .show(ChannelsShowRequest(channelId: channelId));

    ref.read(notesWithProvider).registerAll(result.pinnedNotes ?? []);

    return ChannelDetailState(channel: result);
  }

  @mutation
  Future<void> follow() async {
    await future;

    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await ref
          .read(misskeyPostContextProvider)
          .channels
          .follow(ChannelsFollowRequest(channelId: channelId));
      state = AsyncData(state.requireValue.copyWith.channel(isFollowing: true));
    });
  }

  @mutation
  Future<void> unfollow() async {
    await future;

    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await ref
          .read(misskeyPostContextProvider)
          .channels
          .unfollow(ChannelsUnfollowRequest(channelId: channelId));
      state = AsyncData(
        state.requireValue.copyWith.channel(isFollowing: false),
      );
    });
  }

  @mutation
  Future<void> favorite() async {
    await future;

    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await ref
          .read(misskeyPostContextProvider)
          .channels
          .favorite(ChannelsFavoriteRequest(channelId: channelId));
      state = AsyncData(state.requireValue.copyWith.channel(isFavorited: true));
    });
  }

  @mutation
  Future<void> unfavorite() async {
    await future;

    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await ref
          .read(misskeyPostContextProvider)
          .channels
          .unfavorite(ChannelsUnfavoriteRequest(channelId: channelId));
      state = AsyncData(
        state.requireValue.copyWith.channel(isFavorited: false),
      );
    });
  }
}

@Dependencies([
  ChannelDetail,
  accountContext,
  misskeyPostContext,
  notesWith,
  MisskeyNoteNotifier,
])
class ChannelDetailInfo extends ConsumerWidget {
  final String channelId;

  const ChannelDetailInfo({required this.channelId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(channelDetailProvider(channelId));

    return switch (data) {
      AsyncLoading() => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      AsyncError(:final error, :final stackTrace) => ErrorDetail(
        error: error,
        stackTrace: stackTrace,
      ),
      AsyncData(:final value) => ChannelDetailArea(channel: value.channel),
    };
  }
}

class ChannelDetailArea extends ConsumerWidget {
  final CommunityChannel channel;

  const ChannelDetailArea({required this.channel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        if (channel.bannerUrl != null)
          Image.network(channel.bannerUrl!.toString()),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  S.of(context).channelJoinningCounts(channel.usersCount),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  S.of(context).channelNotes(channel.notesCount),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (channel.lastNotedAt != null)
                  Text(
                    S
                        .of(context)
                        .channelLastNotedAt(
                          channel.lastNotedAt!.differenceNow(context),
                        ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
        if (channel.isSensitive)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  " ${S.of(context).sensitive} ",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Wrap(
          spacing: 5,
          alignment: WrapAlignment.end,
          children: [
            ChannelFavoriteButton(channelId: channel.id),
            ChannelFollowingButton(channelId: channel.id),
            OutlinedButton(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text:
                        "https://${ref.read(accountContextProvider).getAccount.host}/channels/${channel.id}",
                  ),
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).doneCopy),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Icon(Icons.copy),
            ),
          ],
        ),
        MfmText(mfmText: channel.description ?? ""),
        for (final pinnedNote in channel.pinnedNotes ?? [])
          MisskeyNote(note: pinnedNote),
      ],
    );
  }
}

class ChannelFavoriteButton extends ConsumerWidget {
  final String channelId;

  const ChannelFavoriteButton({required this.channelId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(
      channelDetailProvider(
        channelId,
      ).select((value) => value.value?.channel.isFavorited),
    );
    final favorite = ref.watch(channelDetailProvider(channelId).favorite);
    final unfavorite = ref.watch(channelDetailProvider(channelId).unfavorite);
    final isPending =
        favorite.state is PendingMutation ||
        unfavorite.state is PendingMutation;

    return switch (isFavorite) {
      null => const SizedBox.shrink(),
      true => ElevatedButton.icon(
        onPressed: isPending ? null : unfavorite.call,
        icon: const Icon(Icons.check),
        label: Text(S.of(context).favorited),
      ),
      false => OutlinedButton(
        onPressed: isPending ? null : favorite.call,
        child: Text(S.of(context).willFavorite),
      ),
    };
  }
}

class ChannelFollowingButton extends ConsumerWidget {
  final String channelId;

  const ChannelFollowingButton({required this.channelId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFollowing = ref.watch(
      channelDetailProvider(
        channelId,
      ).select((value) => value.value?.channel.isFollowing),
    );
    final follow = ref.watch(channelDetailProvider(channelId).follow);
    final unfollow = ref.watch(channelDetailProvider(channelId).unfollow);
    final isPending =
        follow.state is PendingMutation || unfollow.state is PendingMutation;

    return switch (isFollowing) {
      null => const SizedBox.shrink(),
      true => ElevatedButton.icon(
        onPressed: isPending ? null : unfollow.call,
        icon: const Icon(Icons.favorite_border),
        label: Text(S.of(context).following),
      ),
      false => OutlinedButton(
        onPressed: isPending ? null : follow.call,
        child: Text(S.of(context).willFollow),
      ),
    };
  }
}
