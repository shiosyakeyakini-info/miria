import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
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
  int? ping;

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
      try {
        final onlineUserCountsResponse = await ref
            .read(misskeyProvider(widget.account))
            .getOnlineUsersCount();

        setState(() {
          onlineUsers = onlineUserCountsResponse.count;
        });
      } catch (e, s) {
        //TODO
      }
      try {
        final serverInfoResponse =
            await ref.read(misskeyProvider(widget.account)).serverInfo();
        totalMemories = serverInfoResponse.mem.total;
      } catch (e, s) {
        //TODO
      }

      try {
        final sendDate = DateTime.now();
        final pingResponse =
            await ref.read(misskeyProvider(widget.account)).ping();

        setState(() {
          ping = pingResponse.pong - sendDate.millisecondsSinceEpoch;
        });
      } catch (e, s) {
        //TODO
      }
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
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
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
              const Padding(padding: EdgeInsets.only(top: 10)),
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
                        const Text("応答時間"),
                        if (ping != null)
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: ping!.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                TextSpan(
                                    text: " ミリ秒",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium)
                              ],
                            ),
                          )
                      ])),
                  Expanded(child: Container()),
                ],
              )
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
