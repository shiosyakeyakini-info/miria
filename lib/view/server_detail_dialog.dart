import "dart:async";
import "dart:math";

import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/repository/socket_timeline_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/constants.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "server_detail_dialog.g.dart";

@Riverpod(dependencies: [misskeyGetContext])
Future<int> _onlineCounts(_OnlineCountsRef ref) async {
  final onlineUserCountsResponse =
      await ref.read(misskeyGetContextProvider).getOnlineUsersCount();
  return onlineUserCountsResponse.count;
}

@Riverpod(dependencies: [misskeyGetContext])
Future<int> _totalMemories(_TotalMemoriesRef ref) async {
  final serverInfoResponse =
      await ref.read(misskeyGetContextProvider).serverInfo();
  return serverInfoResponse.mem.total;
}

@Riverpod(dependencies: [misskeyGetContext])
Future<int> _ping(_PingRef ref) async {
  final sendDate = DateTime.now();
  final pingResponse = await ref.read(misskeyGetContextProvider).ping();

  return pingResponse.pong - sendDate.millisecondsSinceEpoch;
}

@RoutePage()
class ServerDetailDialog extends HookConsumerWidget
    implements AutoRouteWrapper {
  final AccountContext accountContext;

  const ServerDetailDialog({
    required this.accountContext,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  String format(double value) {
    return ((value * 10000).toInt() / 100).toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlineUsers = ref.watch(_onlineCountsProvider).valueOrNull;
    final totalMemories = ref.watch(_totalMemoriesProvider).valueOrNull;
    final ping = ref.watch(_pingProvider).valueOrNull;

    final logged = useState(<ServerMetricsResponse>[]);
    final queueLogged = useState(<JobQueueResponse>[]);

    final currentStat = logged.value.lastOrNull;
    final currentQueueStats = queueLogged.value.lastOrNull;
    final queueId = useMemoized(() => const Uuid().v4());
    final statsId = useMemoized(() => const Uuid().v4());

    useEffect(() {
      final misskey = ref.read(misskeyGetContextProvider);
      StreamSubscription<StreamingResponse>? serverStats;
      StreamSubscription<StreamingResponse>? jobQueue;
      StreamingController? streaming;
      unawaited(() async {
        streaming = await ref.read(misskeyStreamingProvider(misskey).future);
        jobQueue = streaming!
            .addChannel(Channel.queueStats, {}, queueId)
            .listen((response) {
          final body = response.body;
          if (body is StatsLogChannelEvent) {
            logged.value = [...logged.value, ...body.body.cast()];
          }
        });

        serverStats = streaming!
            .addChannel(Channel.serverStats, {}, statsId)
            .listen((response) {
          final body = response.body;
          if (body is StatsLogChannelEvent) {
            queueLogged.value = [...queueLogged.value, ...body.body.cast()];
          }
        });
      }());

      return () {
        unawaited(() async {
          await (
            streaming?.removeChannel(queueId) ?? Future.value(),
            streaming?.removeChannel(statsId) ?? Future.value(),
            jobQueue?.cancel() ?? Future.value(),
            serverStats?.cancel() ?? Future.value(),
          ).wait;
        }());
      };
    });

    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(accountContext.getAccount.host)),
          IconButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await context.pushRoute(
                FederationRoute(
                  accountContext: ref.read(accountContextProvider),
                  host: accountContext.getAccount.host,
                ),
              );
            },
            icon: const Icon(Icons.keyboard_arrow_right),
          ),
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
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      ((currentStat.cpu * 10000).toInt() / 100)
                                          .toString(),
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                TextSpan(
                                  text: " %",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        if (logged.value.isNotEmpty)
                          Chart(
                            data: logged.value
                                .skip(max(0, logged.value.length - 41))
                                .mapIndexed(
                                  (index, element) =>
                                      FlSpot(index.toDouble(), element.cpu),
                                )
                                .toList(),
                          ),
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
                                    currentStat.mem.used / totalMemories,
                                  ),
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                TextSpan(
                                  text: " %",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        if (totalMemories != null && logged.value.isNotEmpty)
                          Chart(
                            data: logged.value
                                .skip(max(0, logged.value.length - 41))
                                .mapIndexed(
                                  (index, element) => FlSpot(
                                    index.toDouble(),
                                    element.mem.used / totalMemories,
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                  ),
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
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                TextSpan(
                                  text: " ${S.of(context).milliSeconds}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: IconButton(
                                    onPressed: () =>
                                        ref.invalidate(_pingProvider),
                                    icon: const Icon(Icons.refresh),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
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
                ),
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
                ),
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

  const Chart({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(
            drawHorizontalLine: false,
            drawVerticalLine: false,
          ),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
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
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
