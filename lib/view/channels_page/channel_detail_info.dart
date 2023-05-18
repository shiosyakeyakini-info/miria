import 'package:flutter/material.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ChannelDetailInfo extends ConsumerWidget {
  final String channelId;

  const ChannelDetailInfo({super.key, required this.channelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = AccountScope.of(context);
    return FutureBuilder(
      future: ref
          .read(misskeyProvider(account))
          .channels
          .show(ChannelsShowRequest(channelId: channelId)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        if (data == null) {
          return AlertDialog(
            content: const Text("チャンネル情報の取得に失敗しました。"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("ほい")),
            ],
          );
        }
        Future(() async {
          ref.read(notesProvider(account)).registerAll(data.pinnedNotes ?? []);
        });
        return Column(
          children: [
            if (data.bannerUrl != null)
              Image.network(data.bannerUrl!.toString()),
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
                      "${data.usersCount}人が参加中",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      "${data.notesCount}投稿",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (data.lastNotedAt != null)
                      Text(
                        "${data.lastNotedAt!.differenceNow} に更新",
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            MfmText(data.description ?? ""),
            for (final pinnedNote in data.pinnedNotes ?? [])
              MisskeyNote(note: pinnedNote)
          ],
        );
      },
    );
  }
}
