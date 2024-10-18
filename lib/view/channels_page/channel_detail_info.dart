import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/dialogs/simple_message_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "channel_detail_info.freezed.dart";
part "channel_detail_info.g.dart";

@freezed
class ChannelDetailState with _$ChannelDetailState {
  factory ChannelDetailState({
    required CommunityChannel channel,
    AsyncValue<void>? follow,
    AsyncValue<void>? favorite,
  }) = _ChannelDetailState;
}

@Riverpod(dependencies: [misskeyGetContext, misskeyPostContext, notesWith])
class ChannelDetail extends _$ChannelDetail {
  @override
  Future<ChannelDetailState> build(
    String channelId,
  ) async {
    final result = await ref
        .read(misskeyGetContextProvider)
        .channels
        .show(ChannelsShowRequest(channelId: channelId));

    ref.read(notesWithProvider).registerAll(result.pinnedNotes ?? []);

    return ChannelDetailState(channel: result);
  }

  Future<void> follow() async {
    final before = await future;

    state = AsyncData(
      before.copyWith(
        channel: before.channel.copyWith(isFollowing: true),
        follow: await AsyncValue.guard(
          () async => ref
              .read(misskeyPostContextProvider)
              .channels
              .follow(ChannelsFollowRequest(channelId: channelId)),
        ),
      ),
    );
  }

  Future<void> unfollow() async {
    final before = await future;

    state = AsyncData(
      before.copyWith(
        channel: before.channel.copyWith(isFollowing: false),
        follow: await AsyncValue.guard(
          () async => ref
              .read(misskeyPostContextProvider)
              .channels
              .unfollow(ChannelsUnfollowRequest(channelId: channelId)),
        ),
      ),
    );
  }

  Future<void> favorite() async {
    final before = await future;

    state = AsyncData(
      before.copyWith(
        channel: before.channel.copyWith(isFavorited: true),
        favorite: await AsyncValue.guard(
          () async => ref
              .read(misskeyPostContextProvider)
              .channels
              .favorite(ChannelsFavoriteRequest(channelId: channelId)),
        ),
      ),
    );
  }

  Future<void> unfavorite() async {
    final before = await future;
    state = AsyncData(
      before.copyWith(
        channel: before.channel.copyWith(isFavorited: false),
        favorite: await AsyncValue.guard(
          () async => ref
              .read(misskeyPostContextProvider)
              .channels
              .unfavorite(ChannelsUnfavoriteRequest(channelId: channelId)),
        ),
      ),
    );
  }
}

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
      AsyncError(:final error, :final stackTrace) =>
        ErrorDetail(error: error, stackTrace: stackTrace),
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
                    S.of(context).channelLastNotedAt(
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
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Text(
                  " ${S.of(context).sensitive} ",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            children: [
              ChannelFavoriteButton(
                channelId: channel.id,
                isFavorite: channel.isFavorited,
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              ChannelFollowingButton(
                isFollowing: channel.isFollowing,
                channelId: channel.id,
              ),
            ],
          ),
        ),
        MfmText(mfmText: channel.description ?? ""),
        for (final pinnedNote in channel.pinnedNotes ?? [])
          MisskeyNote(note: pinnedNote),
      ],
    );
  }
}

class ChannelFavoriteButton extends ConsumerWidget {
  final bool? isFavorite;
  final String channelId;

  const ChannelFavoriteButton({
    required this.isFavorite,
    required this.channelId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = channelDetailProvider(channelId);
    final followingState = ref.watch(
      provider.select((value) => value.valueOrNull?.favorite),
    );

    ref.listen(provider.select((value) => value.valueOrNull?.favorite?.error),
        (_, next) async {
      if (next == null) return;
      await SimpleMessageDialog.show(context, next.toString());
    });

    return switch (isFavorite) {
      null => const SizedBox.shrink(),
      true => ElevatedButton.icon(
          onPressed: followingState is AsyncLoading
              ? null
              : ref.read(provider.notifier).unfavorite,
          icon: const Icon(Icons.check),
          label: Text(S.of(context).favorited),
        ),
      false => OutlinedButton(
          onPressed: followingState is AsyncLoading
              ? null
              : ref.read(provider.notifier).favorite,
          child: Text(S.of(context).willFavorite),
        )
    };
  }
}

class ChannelFollowingButton extends ConsumerWidget {
  final bool? isFollowing;
  final String channelId;

  const ChannelFollowingButton({
    required this.isFollowing,
    required this.channelId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = channelDetailProvider(channelId);
    final followState = ref.watch(
      provider.select((value) => value.valueOrNull?.follow),
    );

    ref.listen(provider.select((value) => value.valueOrNull?.follow?.error),
        (_, next) async {
      if (next == null) return;
      await SimpleMessageDialog.show(context, next.toString());
    });

    return switch (isFollowing) {
      null => const SizedBox.shrink(),
      true => ElevatedButton.icon(
          onPressed: followState is AsyncLoading
              ? null
              : ref.read(provider.notifier).unfollow,
          icon: const Icon(Icons.favorite_border),
          label: Text(S.of(context).following),
        ),
      false => OutlinedButton(
          onPressed: followState is AsyncLoading
              ? null
              : ref.read(provider.notifier).follow,
          child: Text(S.of(context).willFollow),
        )
    };
  }
}
