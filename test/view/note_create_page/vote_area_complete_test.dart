import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/account_settings.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/note_create_page/vote_area.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("VoteArea Complete Widget Test", () {
    late Account testAccount;

    setUp(() {
      testAccount = TestData.account;
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          accountContextProvider.overrideWithValue(
            AccountContext(getAccount: testAccount, postAccount: testAccount),
          ),
          accountSettingsRepositoryProvider.overrideWith((ref) {
            final repository = MockAccountSettingsRepository();
            when(repository.fromAccount(any)).thenReturn(
              AccountSettings(
                userId: testAccount.userId,
                host: testAccount.host,
                defaultNoteVisibility: NoteVisibility.public,
                defaultIsLocalOnly: false,
                defaultReactionAcceptance: ReactionAcceptance.nonSensitiveOnly,
              ),
            );
            return repository;
          }),
        ],
        child: DefaultRootNoRouterWidget(
          child: Scaffold(
            body: Column(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      onPressed: () {
                        ref
                            .read(noteCreateProvider.notifier)
                            .toggleVote();
                      },
                      child: Text("Toggle Vote"),
                    );
                  },
                ),
                Expanded(child: VoteArea()),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets("投票が無効の時はVoteAreaが空のコンテナを表示", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 初期状態では投票が無効なので、VoteAreaは空のContainer
      expect(find.byType(VoteArea), findsOneWidget);

      // 投票関連のUIが表示されていないことを確認
      expect(find.byType(TextField), findsNothing);
      expect(find.byType(Switch), findsNothing);
      expect(find.byType(DropdownButton<VoteExpireType>), findsNothing);
    });

    testWidgets("投票を有効にするとVoteAreaの全UIが表示される", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Toggle Voteボタンをタップして投票を有効化
      await tester.tap(find.text("Toggle Vote"));
      await tester.pumpAndSettle();

      // ✅ VoteAreaのUIが表示されることを確認（正しい型パラメータ付き）
      expect(find.byType(TextField), findsWidgets);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(ElevatedButton), findsWidgets);
      expect(find.byType(DropdownButton<VoteExpireType>), findsOneWidget);
    });

    testWidgets("複数選択スイッチの操作ができる", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 投票を有効化
      await tester.tap(find.text("Toggle Vote"));
      await tester.pumpAndSettle();

      // スイッチを見つける
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      // 初期値を取得
      var switchWidget = tester.widget<Switch>(switchFinder);
      final initialValue = switchWidget.value;

      // スイッチをタップ
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // 値が変更されたことを確認
      switchWidget = tester.widget<Switch>(switchFinder);
      expect(switchWidget.value, !initialValue);
    });

    testWidgets("選択肢にテキストを入力できる", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 投票を有効化
      await tester.tap(find.text("Toggle Vote"));
      await tester.pumpAndSettle();

      // テキストフィールドを見つける
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);

      if (textFields.evaluate().isNotEmpty) {
        // 最初のテキストフィールドにテキストを入力
        await tester.enterText(textFields.first, "テスト選択肢1");
        await tester.pumpAndSettle();

        // 入力されたテキストが表示されることを確認
        expect(find.text("テスト選択肢1"), findsOneWidget);
      }
    });

    testWidgets("選択肢追加ボタンが動作する", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 投票を有効化
      await tester.tap(find.text("Toggle Vote"));
      await tester.pumpAndSettle();

      // 初期のテキストフィールド数を記録
      final initialTextFields = find.byType(TextField);
      final initialCount = initialTextFields.evaluate().length;

      // 追加ボタンを見つけてタップ（Toggle Vote以外のElevatedButton）
      final elevatedButtons = find.byType(ElevatedButton);
      for (final buttonElement in elevatedButtons.evaluate()) {
        final button = buttonElement.widget as ElevatedButton;
        if (button.child is Text) {
          final text = (button.child! as Text).data;
          if (text != "Toggle Vote") {
            await tester.tap(find.byWidget(button));
            await tester.pumpAndSettle();
            break;
          }
        }
      }

      // テキストフィールドが増えているか確認
      final newTextFields = find.byType(TextField);
      final newCount = newTextFields.evaluate().length;
      expect(newCount, greaterThan(initialCount));
    });

    testWidgets("選択肢削除ボタンが表示される", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 投票を有効化
      await tester.tap(find.text("Toggle Vote"));
      await tester.pumpAndSettle();

      // 削除ボタン（closeアイコン）が表示されることを確認
      expect(find.byIcon(Icons.close), findsWidgets);
    });

    testWidgets("DropdownButtonメニューが動作する", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 投票を有効化
      await tester.tap(find.text("Toggle Vote"));
      await tester.pumpAndSettle();

      // ✅ DropdownButtonが表示されることを確認（正しい型パラメータ付き）
      final dropdownFinder = find.byType(DropdownButton<VoteExpireType>);
      expect(dropdownFinder, findsOneWidget);

      // DropdownButtonをタップしてメニューを開く
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // ドロップダウンアイテムが表示されることを確認
      expect(find.byType(DropdownMenuItem<VoteExpireType>), findsWidgets);
    });

    testWidgets("投票機能のON/OFF切り替えテスト", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 初期状態では投票エリアが非表示（空のContainer）
      expect(find.byType(Switch), findsNothing);
      expect(find.byType(DropdownButton<VoteExpireType>), findsNothing);

      // 投票ボタンをタップして有効化
      await tester.tap(find.text("Toggle Vote"));
      await tester.pumpAndSettle();

      // 投票エリアが表示される
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(DropdownButton<VoteExpireType>), findsOneWidget);

      // もう一度投票ボタンをタップして無効化
      await tester.tap(find.text("Toggle Vote"));
      await tester.pumpAndSettle();

      // 投票エリアが非表示になる
      expect(find.byType(Switch), findsNothing);
      expect(find.byType(DropdownButton<VoteExpireType>), findsNothing);
    });

    testWidgets("投票状態が保持されることのテスト", (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 投票を有効化
      await tester.tap(find.text("Toggle Vote"));
      await tester.pumpAndSettle();

      // 選択肢にテキストを入力
      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.first, "永続化テスト選択肢");
        await tester.pumpAndSettle();
      }

      // 複数選択を有効化
      final switchWidget = find.byType(Switch);
      await tester.tap(switchWidget);
      await tester.pumpAndSettle();

      // 画面を更新しても状態が保持されることを確認
      await tester.pumpAndSettle();

      // テキストと複数選択状態が保持されていることを確認
      expect(find.text("永続化テスト選択肢"), findsOneWidget);
      final switch_ = tester.widget<Switch>(switchWidget);
      expect(switch_.value, isTrue);
    });
  });
}
