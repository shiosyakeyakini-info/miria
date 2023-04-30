import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/extensions/date_time_extension.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/mfm_text.dart';
import 'package:flutter_misskey_app/view/common/misskey_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ChannelDialog extends ConsumerWidget {
  final String channelId;

  const ChannelDialog({super.key, required this.channelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref
          .read(misskeyProvider)
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
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: Container(
              padding: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorDark),
              child: Text(
                data.name,
                style: TextStyle(color: Theme.of(context).primaryColorLight),
              )),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  if (data.bannerUrl != null)
                    Image.network(data.bannerUrl!.toString()),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor)),
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
                  MfmText(mfmText: data.description ?? ""),
                  for (final pinnedNote in data.pinnedNotes)
                    MisskeyNote(note: pinnedNote)
                ],
              ))),
        );
      },
    );
  }
}
