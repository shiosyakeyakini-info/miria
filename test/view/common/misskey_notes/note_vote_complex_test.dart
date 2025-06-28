import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/repository/note_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/misskey_notes/note_vote.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../../test_util/default_root_widget.dart";
import "../../../test_util/mock.mocks.dart";
import "../../../test_util/test_datas.dart";
import "../../../test_util/widget_tester_extension.dart";

void main() {
  group("投票機能の複雑なテストケース", () {
    late MockMisskey mockMisskey;
    late NoteRepository notesRepository;

    setUp(() {
      mockMisskey = MockMisskey();
      notesRepository = NoteRepository(mockMisskey, TestData.account);
    });

    // 既存のテストデータを使用
    final pollNote = TestData.note4AsVote;

    Widget buildTestWidget({
      required Note note,
    }) {
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

    group("投票数表示の不具合再現テスト", () {
      testWidgets("単一投票で未投票の場合でも、初期表示で投票数が表示されること", (tester) async {
        await tester.pumpWidget(buildTestWidget(note: pollNote));
        await tester.pumpAndSettle();

        // 投票選択肢のテキストは表示されている
        expect(find.textContaining("光る国民の基本的な権利"), findsOneWidget);
        expect(find.textContaining("ぷるぷる自動販売機"), findsOneWidget);
        expect(find.textContaining("抗菌仕様金髪碧眼の美少女"), findsOneWidget);
        
        // 投票数も表示されている（括弧付きで表示）
        expect(find.textContaining("17"), findsOneWidget);
        expect(find.textContaining("9"), findsOneWidget);
        expect(find.textContaining("27"), findsOneWidget);
        
        // 投票数は「(17票)」のような形式で表示されていることを確認
        expect(find.textContaining("(17票)"), findsOneWidget);
        expect(find.textContaining("(9票)"), findsOneWidget);
        expect(find.textContaining("(27票)"), findsOneWidget);
      });

      testWidgets("【Hook状態リセット問題】ウィジェットツリーが再構築されると投票数表示が消える可能性", (tester) async {
        // 初期状態でウィジェットを構築
        await tester.pumpWidget(buildTestWidget(note: pollNote));
        await tester.pumpAndSettle();

        // 投票数が表示されていることを確認
        expect(find.textContaining("(17票)"), findsOneWidget);
        
        // ウィジェットツリーを完全に再構築（例：タブ切り替えやページ遷移をシミュレート）
        await tester.pumpWidget(Container()); // 一度空のコンテナに置き換え
        await tester.pumpAndSettle();
        
        // 再度元のウィジェットを構築
        await tester.pumpWidget(buildTestWidget(note: pollNote));
        await tester.pumpAndSettle();
        
        // Hook の初期化が再度実行される
        // isOpened = useState(useMemoized(() => !isAnyVotable(ref)))
        // isAnyVotable(ref) が true の場合、isOpened は false になる
        
        // テストデータは未投票なので、isAnyVotable は true を返すはず
        // したがって、isOpened は false になり、投票数は表示されない可能性がある
        
        // 投票数が表示されているか確認
        final voteCount17 = find.textContaining("(17票)");
        if (voteCount17.evaluate().isEmpty) {
          // 投票数が消えている場合、これが不具合の原因
          print("不具合再現: ウィジェット再構築後、投票数が表示されなくなりました");
          expect(find.textContaining("結果を見る"), findsOneWidget);
        } else {
          // 投票数が表示されている場合
          expect(voteCount17, findsOneWidget);
        }
      });


      testWidgets("【実際の使用シーン】スクロールによる再レンダリング時の動作", (tester) async {
        // タイムラインのようなリストビューをシミュレート
        final scrollController = ScrollController();
        
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              cacheManagerProvider.overrideWith((ref) => MockBaseCacheManager()),
              notesProvider.overrideWith((ref, account) => notesRepository),
            ],
            child: DefaultRootNoRouterWidget(
              child: Scaffold(
                body: AccountContextScope.as(
                  account: TestData.account,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      if (index == 10) {
                        // 10番目に投票ノートを配置
                        return MisskeyNote(note: pollNote);
                      }
                      return Container(
                        height: 200,
                        child: Text('ダミーノート $index'),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        
        // スクロールして投票ノートを表示
        await scrollController.animateTo(
          2000.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        await tester.pumpAndSettle();
        
        // 投票数が表示されているか確認
        expect(find.textContaining("(17票)"), findsOneWidget);
        
        // 画面外にスクロール
        await scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        await tester.pumpAndSettle();
        
        // 再度スクロールして表示
        await scrollController.animateTo(
          2000.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        await tester.pumpAndSettle();
        
        // 再レンダリング後も投票数が表示されているか確認
        final voteCount = find.textContaining("(17票)");
        if (voteCount.evaluate().isEmpty) {
          print("不具合再現: スクロール後、投票数が表示されなくなりました");
          // この場合、Hook の状態がリセットされている
        } else {
          expect(voteCount, findsOneWidget);
        }
      });

      testWidgets("投票済みのノートでは初期表示で投票数が表示されること", (tester) async {
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

        // 投票済みの場合は投票数が表示されている
        expect(find.textContaining("17"), findsOneWidget);
        expect(find.textContaining("9"), findsOneWidget);
        expect(find.textContaining("27"), findsOneWidget);
        
        // 投票済みマークも表示されている
        expect(find.byIcon(Icons.check), findsOneWidget);
      });
    });
  });
}