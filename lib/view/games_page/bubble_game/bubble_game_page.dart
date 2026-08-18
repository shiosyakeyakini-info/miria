import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/bubble_game/mono.dart";
import "package:miria/providers.dart";
import "package:miria/repository/bubble_game_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/games_page/bubble_game/bubble_game_mode_extension.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "bubble_game_page.g.dart";

/// バブルゲームのモード選択とランキング。
@RoutePage()
class BubbleGamePage extends ConsumerStatefulWidget
    implements AutoRouteWrapper {
  const BubbleGamePage({required this.accountContext, super.key});

  final AccountContext accountContext;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  ConsumerState<BubbleGamePage> createState() => _BubbleGamePageState();
}

class _BubbleGamePageState extends ConsumerState<BubbleGamePage> {
  var _gameMode = BubbleGameMode.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).bubbleGame)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            S.of(context).bubbleGameSelectMode,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final mode in BubbleGameMode.values)
                ChoiceChip(
                  label: Text(mode.displayName(context)),
                  selected: _gameMode == mode,
                  onSelected: (_) => setState(() => _gameMode = mode),
                ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              await context.pushRoute(
                BubbleGamePlayRoute(
                  accountContext: widget.accountContext,
                  gameMode: _gameMode,
                ),
              );
              // 遊んだあとに戻ってきたら、いま出したスコアも見えるようにする
              if (!context.mounted) return;
              ref.invalidate(_rankingProvider(_gameMode));
            },
            icon: const Icon(Icons.play_arrow),
            label: Text(_gameMode.displayName(context)),
          ),
          const SizedBox(height: 24),
          Text(
            S.of(context).bubbleGameRanking,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _Ranking(gameMode: _gameMode),
        ],
      ),
    );
  }
}

// bubbleGameRepositoryProvider はアカウントごとにスコープされるので、
// ここで読むならdependenciesに並べておく必要がある
@Riverpod(dependencies: [bubbleGameRepository])
Future<List<BubbleGameRankingResponse>> _ranking(
  Ref ref,
  BubbleGameMode gameMode,
) => ref.read(bubbleGameRepositoryProvider).ranking(gameMode);

class _Ranking extends ConsumerWidget {
  const _Ranking({required this.gameMode});

  final BubbleGameMode gameMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ranking = ref.watch(_rankingProvider(gameMode));

    return switch (ranking) {
      AsyncLoading() => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      AsyncError(:final error, :final stackTrace) => ErrorDetail(
        error: error,
        stackTrace: stackTrace,
      ),
      AsyncData(:final value) =>
        value.isEmpty
            ? Text(S.of(context).bubbleGameRankingEmpty)
            : Column(
                children: [
                  for (final (index, record) in value.indexed)
                    ListTile(
                      leading: Text("${index + 1}"),
                      title: Row(
                        children: [
                          AvatarIcon(user: record.user),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              record.user.name ?? record.user.username,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text("${record.score}${gameMode.scoreUnit}"),
                    ),
                ],
              ),
    };
  }
}
