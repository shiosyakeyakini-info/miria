import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/repository/note_repository.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:misskey_dart/misskey_dart.dart";

import "../../../test_util/default_root_widget.dart";
import "../../../test_util/mock.mocks.dart";
import "../../../test_util/test_datas.dart";

void main() {
  group("投票数表示不具合修正のテスト", () {
    // 期限切れではない投票データを作成
    final pollNote = TestData.note4AsVote.copyWith(
      poll: TestData.note4AsVote.poll!.copyWith(
        expiresAt: DateTime.now().add(const Duration(hours: 1)), // 1時間後に期限切れ
      ),
    );

    Widget buildTestWidget({required Note note}) {
      final mockMisskey = MockMisskey();
      final notesRepository = NoteRepository(mockMisskey, TestData.account);
      notesRepository.registerNote(note);
      final mockCacheManager = MockBaseCacheManager();

      return ProviderScope(
        overrides: [
          cacheManagerProvider.overrideWith((ref) => mockCacheManager),
          notesProvider.overrideWith((ref, account) => notesRepository),
        ],
        child: DefaultRootNoRouterWidget(
          child: Scaffold(
            body: AccountContextScope.as(
              account: TestData.account,
              child: SingleChildScrollView(child: MisskeyNote(note: note)),
            ),
          ),
        ),
      );
    }

    testWidgets("【修正後】ウィジェット再構築後も投票数表示状態が保持されること", (tester) async {
      // 同じRepositoryインスタンスを使用
      final mockMisskey = MockMisskey();
      final notesRepository = NoteRepository(mockMisskey, TestData.account);
      notesRepository.registerNote(pollNote);
      final mockCacheManager = MockBaseCacheManager();

      Widget buildTestWidgetWithSharedRepo() {
        return ProviderScope(
          overrides: [
            cacheManagerProvider.overrideWith((ref) => mockCacheManager),
            notesProvider.overrideWith((ref, account) => notesRepository),
          ],
          child: DefaultRootNoRouterWidget(
            child: Scaffold(
              body: AccountContextScope.as(
                account: TestData.account,
                child: SingleChildScrollView(child: MisskeyNote(note: pollNote)),
              ),
            ),
          ),
        );
      }

      // 初期状態でウィジェットを構築
      await tester.pumpWidget(buildTestWidgetWithSharedRepo());
      await tester.pumpAndSettle();

      // 修正後：初期状態では投票数は非表示
      expect(find.textContaining("(17票)"), findsNothing);
      expect(find.textContaining("結果を見る"), findsOneWidget);
      
      // 「結果を見る」をタップして投票数を表示
      await tester.tap(find.textContaining("結果を見る"));
      await tester.pumpAndSettle();
      
      // 投票数が表示されていることを確認
      expect(find.textContaining("(17票)"), findsOneWidget);
      expect(find.textContaining("(9票)"), findsOneWidget);
      expect(find.textContaining("(27票)"), findsOneWidget);
      
      // ウィジェットツリーを完全に再構築
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
      
      // 再度元のウィジェットを構築（同じRepositoryを使用）
      await tester.pumpWidget(buildTestWidgetWithSharedRepo());
      await tester.pumpAndSettle();
      
      // 修正後は状態が保持されているため、投票数が表示されたまま
      expect(find.textContaining("(17票)"), findsOneWidget);
      expect(find.textContaining("(9票)"), findsOneWidget);
      expect(find.textContaining("(27票)"), findsOneWidget);
    });

    testWidgets("【修正後】投票済みノートは初期表示で投票数が表示されること", (tester) async {
      // 投票済みのノートを作成
      final votedNote = pollNote.copyWith(
        poll: pollNote.poll!.copyWith(
          choices: [
            pollNote.poll!.choices[0].copyWith(isVoted: true),
            pollNote.poll!.choices[1],
            pollNote.poll!.choices[2],
            pollNote.poll!.choices[3],
          ],
        ),
      );
      
      await tester.pumpWidget(buildTestWidget(note: votedNote));
      await tester.pumpAndSettle();

      // 投票済みの場合は初期表示で投票数が表示される
      expect(find.textContaining("(17票)"), findsOneWidget);
      expect(find.textContaining("(9票)"), findsOneWidget);
      expect(find.textContaining("(27票)"), findsOneWidget);
      
      // ウィジェット再構築後も表示状態が保持される
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
      await tester.pumpWidget(buildTestWidget(note: votedNote));
      await tester.pumpAndSettle();
      
      expect(find.textContaining("(17票)"), findsOneWidget);
      expect(find.textContaining("(9票)"), findsOneWidget);
      expect(find.textContaining("(27票)"), findsOneWidget);
    });

    testWidgets("【修正後】期限切れ投票は初期表示で投票数が表示されること", (tester) async {
      // 期限切れの投票ノートを作成
      final expiredPollNote = pollNote.copyWith(
        poll: pollNote.poll!.copyWith(
          expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      );
      
      await tester.pumpWidget(buildTestWidget(note: expiredPollNote));
      await tester.pumpAndSettle();

      // 期限切れの場合は初期表示で投票数が表示される
      expect(find.textContaining("(17票)"), findsOneWidget);
      expect(find.textContaining("(9票)"), findsOneWidget);
      expect(find.textContaining("(27票)"), findsOneWidget);
      
      // 「終了済み」が表示される
      expect(find.textContaining("終了済み"), findsOneWidget);
    });

    testWidgets("【修正後】未投票の投票は初期状態で投票数が非表示であること", (tester) async {
      await tester.pumpWidget(buildTestWidget(note: pollNote));
      await tester.pumpAndSettle();

      // 修正後：初期状態では投票数は非表示
      expect(find.textContaining("(17票)"), findsNothing);
      expect(find.textContaining("結果を見る"), findsOneWidget);
    });
    
    testWidgets("【修正後】投票数表示の切り替えが正しく動作すること", (tester) async {
      await tester.pumpWidget(buildTestWidget(note: pollNote));
      await tester.pumpAndSettle();

      // 初期状態では投票数は非表示
      expect(find.textContaining("(17票)"), findsNothing);
      
      // 「結果を見る」をタップ
      await tester.tap(find.textContaining("結果を見る"));
      await tester.pumpAndSettle();
      
      // 投票数が表示される
      expect(find.textContaining("(17票)"), findsOneWidget);
      
      // 再度タップして非表示にする
      await tester.tap(find.textContaining("投票する"));
      await tester.pumpAndSettle();
      
      // 投票数が非表示になる
      expect(find.textContaining("(17票)"), findsNothing);
      expect(find.textContaining("結果を見る"), findsOneWidget);
    });
  });
}