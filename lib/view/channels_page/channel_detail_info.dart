import 'package:flutter/material.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChannelDetailInfo extends ConsumerStatefulWidget {
  final String channelId;

  const ChannelDetailInfo({super.key, required this.channelId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ChannelDetailInfoState();
}

class ChannelDetailInfoState extends ConsumerState<ChannelDetailInfo> {
  CommunityChannel? data;
  (Object?, StackTrace)? error;

  Future<void> follow() async {
    await ref
        .read(misskeyProvider(AccountScope.of(context)))
        .channels
        .follow(ChannelsFollowRequest(channelId: widget.channelId));
    setState(() {
      data = data?.copyWith(isFollowing: true);
    });
  }

  Future<void> unfollow() async {
    await ref
        .read(misskeyProvider(AccountScope.of(context)))
        .channels
        .unfollow(ChannelsUnfollowRequest(channelId: widget.channelId));
    setState(() {
      data = data?.copyWith(isFollowing: false);
    });
  }

  Future<void> favorite() async {
    await ref
        .read(misskeyProvider(AccountScope.of(context)))
        .channels
        .favorite(ChannelsFavoriteRequest(channelId: widget.channelId));
    setState(() {
      data = data?.copyWith(isFavorited: true);
    });
  }

  Future<void> unfavorite() async {
    await ref
        .read(misskeyProvider(AccountScope.of(context)))
        .channels
        .unfavorite(ChannelsUnfavoriteRequest(channelId: widget.channelId));
    setState(() {
      data = data?.copyWith(isFavorited: false);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      try {
        final account = AccountScope.of(context);
        final result = await ref
            .read(misskeyProvider(AccountScope.of(context)))
            .channels
            .show(ChannelsShowRequest(channelId: widget.channelId));

        ref.read(notesProvider(account)).registerAll(result.pinnedNotes ?? []);
        if (!mounted) return;
        setState(() {
          data = result;
        });
      } catch (e, s) {
        if (!mounted) return;
        setState(() {
          error = (e, s);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = this.data;
    final isFavorited = data?.isFavorited;
    final isFollowing = data?.isFollowing;

    if (data == null) {
      if (error == null) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return ErrorDetail(error: error?.$1, stackTrace: error?.$2);
      }
    }

    return Column(
      children: [
        if (data.bannerUrl != null) Image.network(data.bannerUrl!.toString()),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor)),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  S.of(context).channelJoinningCounts(data.usersCount),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  S.of(context).channelNotes(data.notesCount),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (data.lastNotedAt != null)
                  Text(
                    S.of(context).channelLastNotedAt(
                          data.lastNotedAt!.differenceNow(context),
                        ),
                    style: Theme.of(context).textTheme.bodySmall,
                  )
              ],
            ),
          ),
        ),
        if (data.isSensitive)
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
                          onPressed: unfavorite.expectFailure(context),
                          icon: const Icon(Icons.favorite_border),
                          label: Text(S.of(context).favorite))
                      : OutlinedButton(
                          onPressed: favorite.expectFailure(context),
                          child: Text(S.of(context).willFavorite)),
                const Padding(padding: EdgeInsets.only(left: 10)),
                if (isFollowing != null)
                  isFollowing
                      ? ElevatedButton.icon(
                          onPressed: unfollow.expectFailure(context),
                          icon: const Icon(Icons.check),
                          label: Text(S.of(context).following))
                      : OutlinedButton(
                          onPressed: follow.expectFailure(context),
                          child: Text(S.of(context).willFollow))
              ],
            )),
        MfmText(mfmText: data.description ?? ""),
        for (final pinnedNote in data.pinnedNotes ?? [])
          MisskeyNote(note: pinnedNote)
      ],
    );
  }
}
