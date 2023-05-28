import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ServerDetailDialog extends ConsumerStatefulWidget {
  //TODO: 本当はサーバー情報取るのにアカウントいらない...
  final Account account;

  const ServerDetailDialog({
    super.key,
    required this.account,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ServerDetailDialogState();
}

class ServerDetailDialogState extends ConsumerState<ServerDetailDialog> {
  SocketController? controller;
  int? onlineUsers;
  int? totalMemories;

  List<StatsLogResponse> logged = [];

  @override
  void dispose() {
    super.dispose();
    controller?.disconnect();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller?.disconnect();
    controller = ref.read(misskeyProvider(widget.account)).serverStatsLogStream(
        (response) => {
              //TODO
            }, (response) {
      setState(() {
        logged.add(response);
      });
    })
      ..startStreaming();

    Future(() async {
      final onlineUserCountsResponse =
          await ref.read(misskeyProvider(widget.account)).getOnlineUsersCount();
      final serverInfoResponse =
          await ref.read(misskeyProvider(widget.account)).serverInfo();

      setState(() {
        onlineUsers = onlineUserCountsResponse.count;
        totalMemories = serverInfoResponse.mem.total;
      });
    });
  }

  String format(double value) {
    return ((value * 10000).toInt() / 100).toString();
  }

  @override
  Widget build(BuildContext context) {
    final currentStat = logged.lastOrNull;
    return AlertDialog(
      title: Text(widget.account.host),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("サーバーオンライン人数"),
            if (onlineUsers != null)
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: onlineUsers.toString(),
                    style: Theme.of(context).textTheme.headlineSmall),
                TextSpan(
                    text: " 人", style: Theme.of(context).textTheme.bodyMedium)
              ])),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("CPU使用率"),
                      if (currentStat != null)
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: ((currentStat.cpu * 10000).toInt() / 100)
                                  .toString(),
                              style: Theme.of(context).textTheme.headlineSmall),
                          TextSpan(
                              text: " %",
                              style: Theme.of(context).textTheme.bodyMedium)
                        ]))
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("メモリ使用率"),
                      if (currentStat != null && totalMemories != null)
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: format(
                                      currentStat.mem.used / totalMemories!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              TextSpan(
                                  text: " %",
                                  style: Theme.of(context).textTheme.bodyMedium)
                            ],
                          ),
                        )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
