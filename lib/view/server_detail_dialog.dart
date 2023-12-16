import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/constants.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  SocketController? queueController;
  int? onlineUsers;
  int? totalMemories;
  int? ping;

  List<StatsLogResponse> logged = [];
  List<QueueStatsLogResponse> queueLogged = [];

  @override
  void dispose() {
    super.dispose();
    controller?.disconnect();
    queueController?.disconnect();
  }

  @override
  void didChangeDependencies() {
    final misskey = ref.read(misskeyProvider(widget.account));
    super.didChangeDependencies();
    controller?.disconnect();
    controller = misskey.serverStatsLogStream(
      (response) => setState(() {
        logged.insertAll(0, response);
      }),
      (response) {
        setState(() {
          logged.add(response);
        });
      },
    );
    queueController?.disconnect();
    queueController = misskey.queueStatsLogStream(
      (response) => setState(() {
        queueLogged.insertAll(0, response);
      }),
      (response) {
        setState(() {
          queueLogged.add(response);
        });
      },
    );
    misskey.startStreaming();

    Future(() async {
      try {
        final onlineUserCountsResponse = await ref
            .read(misskeyProvider(widget.account))
            .getOnlineUsersCount();

        if (!mounted) return;
        setState(() {
          onlineUsers = onlineUserCountsResponse.count;
        });
      } catch (e) {
        //TODO
      }
      try {
        final serverInfoResponse =
            await ref.read(misskeyProvider(widget.account)).serverInfo();
        if (!mounted) return;
        setState(() {
          totalMemories = serverInfoResponse.mem.total;
        });
      } catch (e) {
        //TODO
      }

      await refreshPing();
    });
  }

  Future<void> refreshPing() async {
    try {
      final sendDate = DateTime.now();
      final pingResponse =
          await ref.read(misskeyProvider(widget.account)).ping();

      if (!mounted) return;
      setState(() {
        ping = pingResponse.pong - sendDate.millisecondsSinceEpoch;
      });
    } catch (e) {
      //TODO
    }
  }

  String format(double value) {
    return ((value * 10000).toInt() / 100).toString();
  }

  @override
  Widget build(BuildContext context) {
    final currentStat = logged.lastOrNull;
    final currentQueueStats = queueLogged.lastOrNull;
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(widget.account.host)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pushRoute(FederationRoute(
                    account: widget.account, host: widget.account.host));
              },
              icon: const Icon(Icons.keyboard_arrow_right))
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).onlineUsers),
              if (onlineUsers != null)
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: onlineUsers.format(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextSpan(
                        text: " ${S.of(context).persons}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).cpuUsageRate),
                        if (currentStat != null)
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: ((currentStat.cpu * 10000).toInt() / 100)
                                    .toString(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            TextSpan(
                                text: " %",
                                style: Theme.of(context).textTheme.bodyMedium)
                          ])),
                        if (logged.isNotEmpty)
                          Chart(
                              data: logged
                                  .skip(max(0, logged.length - 41))
                                  .mapIndexed((index, element) =>
                                      FlSpot(index.toDouble(), element.cpu))
                                  .toList())
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).memoryUsageRate),
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium)
                              ],
                            ),
                          ),
                        if (totalMemories != null && logged.isNotEmpty)
                          Chart(
                              data: logged
                                  .skip(max(0, logged.length - 41))
                                  .mapIndexed((index, element) => FlSpot(
                                      index.toDouble(),
                                      element.mem.used / totalMemories!))
                                  .toList())
                      ],
                    ),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(S.of(context).responseTime),
                        if (ping != null)
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: ping.format(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                TextSpan(
                                  text: " ${S.of(context).milliSeconds}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: IconButton(
                                        onPressed: () => refreshPing(),
                                        icon: const Icon(Icons.refresh)))
                              ],
                            ),
                          )
                      ])),
                  Expanded(child: Container()),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(S.of(context).inboxQueue),
              if (currentQueueStats != null) ...[
                Row(
                  children: [
                    Expanded(child: Text(S.of(context).inboxProcessQueue)),
                    Expanded(child: Text(S.of(context).inboxActiveQueue)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentQueueStats.inbox.activeSincePrevTick.format(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: Text(
                        currentQueueStats.inbox.active.format(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text(S.of(context).inboxDelayedQueue)),
                    Expanded(child: Text(S.of(context).inboxWaitingQueue)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentQueueStats.inbox.delayed.format(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: Text(
                        currentQueueStats.inbox.waiting.format(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                )
              ],
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(S.of(context).deliverQueue),
              if (currentQueueStats != null) ...[
                Row(
                  children: [
                    Expanded(child: Text(S.of(context).deliverProcessQueue)),
                    Expanded(child: Text(S.of(context).deliverActiveQueue)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentQueueStats.deliver.activeSincePrevTick.format(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: Text(
                        currentQueueStats.deliver.active.format(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text(S.of(context).deliverDelayedQueue)),
                    Expanded(child: Text(S.of(context).deliverWaitingQueue)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentQueueStats.deliver.delayed.format(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: Text(
                        currentQueueStats.deliver.waiting.format(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class Chart extends StatelessWidget {
  final List<FlSpot> data;

  const Chart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            drawHorizontalLine: false,
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(enabled: false),
          minX: 0,
          maxX: 40,
          minY: 0,
          maxY: 1,
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              color:
                  Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(200),
              barWidth: 4,
              belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).textTheme.bodyMedium?.color),
              dotData: FlDotData(show: false),
            )
          ],
        ),
      ),
    );
  }
}
