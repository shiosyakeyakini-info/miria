import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
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

@riverpod
class _ChannelDetail extends _$ChannelDetail {
  @override
  Future<ChannelDetailState> build(
    Account account,
    String channelId,
  ) async {
    final result = await ref
        .read(misskeyProvider(account))
        .channels
        .show(ChannelsShowRequest(channelId: channelId));

    ref.read(notesProvider(account)).registerAll(result.pinnedNotes ?? []);

    return ChannelDetailState(channel: result);
  }

  Future<void> follow() async {
    final before = await future;

    state = AsyncData(
      before.copyWith(
        channel: before.channel.copyWith(isFollowing: true),
        follow: await AsyncValue.guard(
          () async => ref
              .read(misskeyProvider(account))
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
              .read(misskeyProvider(account))
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
              .read(misskeyProvider(account))
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
              .read(misskeyProvider(account))
              .channels
              .unfavorite(ChannelsUnfavoriteRequest(channelId: channelId)),
        ),
      ),
    );
  }
}

class ChannelDetailInfo extends ConsumerStatefulWidget {
  final String channelId;

  const ChannelDetailInfo({required this.channelId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ChannelDetailInfoState();
}

class ChannelDetailInfoState extends ConsumerState<ChannelDetailInfo> {
  @override
  Widget build(BuildContext context) {
    final provider =
        _channelDetailProvider(AccountScope.of(context), widget.channelId);
    final data = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    final isFavorited = data.valueOrNull?.channel.isFavorited;
    final isFollowing = data.valueOrNull?.channel.isFollowing;

    ref
      ..listen(provider.select((value) => value.valueOrNull?.follow?.error),
          (_, next) async {
        if (next == null) return;
        await SimpleMessageDialog.show(context, next.toString());
      })
      ..listen(provider.select((value) => value.valueOrNull?.favorite?.error),
          (_, next) async {
        if (next == null) return;
        await SimpleMessageDialog.show(context, next.toString());
      });

    return switch (data) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error, :final stackTrace) =>
        ErrorDetail(error: error, stackTrace: stackTrace),
      AsyncData(:final value) => Column(
          children: [
            if (value.channel.bannerUrl != null)
              Image.network(value.channel.bannerUrl!.toString()),
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
                      S
                          .of(context)
                          .channelJoinningCounts(value.channel.usersCount),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      S.of(context).channelNotes(value.channel.notesCount),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (value.channel.lastNotedAt != null)
                      Text(
                        S.of(context).channelLastNotedAt(
                              value.channel.lastNotedAt!.differenceNow(context),
                            ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ),
            if (value.channel.isSensitive)
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
                  if (isFavorited != null)
                    isFavorited
                        ? ElevatedButton.icon(
                            onPressed: notifier.unfavorite,
                            icon: const Icon(Icons.favorite_border),
                            label: Text(S.of(context).favorite),
                          )
                        : OutlinedButton(
                            onPressed: notifier.favorite,
                            child: Text(S.of(context).willFavorite),
                          ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  if (isFollowing != null)
                    isFollowing
                        ? ElevatedButton.icon(
                            onPressed: notifier.unfollow,
                            icon: const Icon(Icons.check),
                            label: Text(S.of(context).following),
                          )
                        : OutlinedButton(
                            onPressed: notifier.follow,
                            child: Text(S.of(context).willFollow),
                          ),
                ],
              ),
            ),
            MfmText(mfmText: value.channel.description ?? ""),
            for (final pinnedNote in value.channel.pinnedNotes ?? [])
              MisskeyNote(note: pinnedNote),
          ],
        )
    };
  }
}
