import 'package:flutter/material.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/channels_page/channel_detail_info.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ChannelDialog extends ConsumerWidget {
  final String channelId;
  final Account account;
  const ChannelDialog(
      {super.key, required this.channelId, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountScope(
        account: account,
        child: AlertDialog(
            titlePadding: EdgeInsets.zero,
            title: Container(
                padding: const EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColorDark),
                child: Text(
                  "チャンネル情報",
                  style: TextStyle(color: Theme.of(context).primaryColorLight),
                )),
            content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: ChannelDetailInfo(
                    channelId: channelId,
                  ),
                ))));
  }
}
