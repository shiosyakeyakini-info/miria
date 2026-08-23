import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/reversi/reversi_matching_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:misskey_dart/misskey_dart.dart";

/// リバーシのマッチング画面。
///
/// 招待に応じるか、誰かを誘うか、誰でもよいマッチングに並ぶかで対局を始める。
@RoutePage()
class ReversiPage extends ConsumerWidget implements AutoRouteWrapper {
  const ReversiPage({required this.accountContext, super.key});

  final AccountContext accountContext;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // マッチが成立したら対局画面へ移る。招待に応じたときも、相手が自分の
    // 招待に応じたとき (`matched` イベント) も同じ経路を通る。
    ref.listen(reversiMatchingProvider, (_, next) {
      final gameId = next.value?.matchedGameId;
      if (gameId == null) return;
      ref.read(reversiMatchingProvider.notifier).consumeMatched();
      unawaited(
        context.pushRoute(
          ReversiGameRoute(accountContext: accountContext, gameId: gameId),
        ),
      );
    });

    final state = ref.watch(reversiMatchingProvider);

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).reversi)),
      body: switch (state) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError(:final error, :final stackTrace) => Center(
          child: ErrorDetail(error: error, stackTrace: stackTrace),
        ),
        // 相手を待っている間は待機画面に切り替える。一覧を出したままにすると、
        // 募集を畳まないまま別の対局へ入れてしまう。
        AsyncData(:final value) when value.isMatching => _WaitingScreen(
          state: value,
        ),
        AsyncData(:final value) => _MatchingList(
          state: value,
          accountContext: accountContext,
        ),
      },
    );
  }
}

class _WaitingScreen extends ConsumerWidget {
  const _WaitingScreen({required this.state});

  final ReversiMatchingState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = state.matchingUser;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            key: const Key("reversi-waiting"),
            user == null
                ? S.of(context).reversiMatching
                : S.of(context).reversiWaitingFor(user.name ?? user.username),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            key: const Key("reversi-cancel-matching"),
            onPressed: () async =>
                ref.read(reversiMatchingProvider.notifier).cancelMatching(),
            child: Text(S.of(context).reversiCancelMatching),
          ),
        ],
      ),
    );
  }
}

class _MatchingList extends ConsumerWidget {
  const _MatchingList({required this.state, required this.accountContext});

  final ReversiMatchingState state;
  final AccountContext accountContext;

  /// 誰でもよいマッチングを、変則ルールの可否を選ばせてから始める。
  Future<void> _matchAnyone(BuildContext context, WidgetRef ref) async {
    final noIrregularRules = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const Key("reversi-allow-irregular"),
              title: Text(S.of(context).reversiAllowIrregularRules),
              onTap: () => Navigator.of(context).pop(false),
            ),
            ListTile(
              key: const Key("reversi-disallow-irregular"),
              title: Text(S.of(context).reversiDisallowIrregularRules),
              onTap: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );
    if (noIrregularRules == null) return;

    await ref
        .read(reversiMatchingProvider.notifier)
        .matchAnyone(noIrregularRules: noIrregularRules);
  }

  /// 相手を選んで招待する。
  Future<void> _invite(BuildContext context, WidgetRef ref) async {
    // リバーシは同一サーバー内でしか遊べないのでローカルに絞る。
    final user = await context.pushRoute<User?>(
      UserSelectRoute(accountContext: accountContext, isLocalOnly: true),
    );
    if (user == null) return;

    await ref.read(reversiMatchingProvider.notifier).invite(user);
  }

  /// 招待に応じる。切れていたらその場で伝える。
  Future<void> _accept(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) async {
    final accepted = await ref
        .read(reversiMatchingProvider.notifier)
        .accept(userId);
    if (accepted || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).reversiInvitationExpired)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(reversiMatchingProvider.future),
      child: ListView(
        children: [
          ListTile(
            key: const Key("reversi-match-anyone"),
            leading: const Icon(Icons.people),
            title: Text(S.of(context).reversiMatchAnyone),
            onTap: () async => _matchAnyone(context, ref),
          ),
          ListTile(
            key: const Key("reversi-invite"),
            leading: const Icon(Icons.person_add),
            title: Text(S.of(context).reversiInvite),
            onTap: () async => _invite(context, ref),
          ),
          const Divider(),
          _SectionHeader(title: S.of(context).reversiInvitations),
          if (state.invitations.isEmpty)
            ListTile(
              title: Text(S.of(context).nonInvitedReversi),
              enabled: false,
            ),
          for (final user in state.invitations)
            ListTile(
              key: Key("reversi-invitation-${user.username}"),
              title: Text(user.name ?? user.username),
              subtitle: Text("@${user.username}"),
              leading: const Icon(Icons.mail),
              onTap: () async => _accept(context, ref, user.id),
            ),
          const Divider(),
          _SectionHeader(title: S.of(context).reversiMyGames),
          if (state.games.isEmpty)
            ListTile(title: Text(S.of(context).reversiNoGames), enabled: false),
          for (final game in state.games)
            ListTile(
              key: Key("reversi-game-${game.id}"),
              title: Text("${game.user1.username} vs ${game.user2.username}"),
              subtitle: Text(
                game.isEnded
                    ? S.of(context).reversiFinished
                    : S.of(context).reversiPlaying,
              ),
              leading: Icon(
                game.isEnded ? Icons.flag : Icons.play_circle_outline,
              ),
              onTap: () async => context.pushRoute(
                ReversiGameRoute(
                  accountContext: accountContext,
                  gameId: game.id,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Text(title, style: Theme.of(context).textTheme.titleSmall),
  );
}
