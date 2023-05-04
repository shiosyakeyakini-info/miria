import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/extensions/date_time_extension.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/channels_page/channel_detail_info.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/mfm_text.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/misskey_note.dart';
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
