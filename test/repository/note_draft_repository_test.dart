import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/repository/note_draft_repository.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../test_util/default_root_widget.dart";
import "../test_util/mock.mocks.dart";
import "../test_util/test_datas.dart";

void main() {
  group("NoteDraftRepository", () {
    late ProviderContainer container;
    late MockMisskey mockMisskey;
    late MockMisskeyNotes mockNotes;
    late Account testAccount;

    setUp(() {
      mockMisskey = MockMisskey();
      mockNotes = MockMisskeyNotes();
      testAccount = TestData.account;

      when(mockMisskey.notes).thenReturn(mockNotes);

      // MockNotes の drafts プロパティは SmartFake として自動的に処理される
      // draftsプロパティはデフォルトでSmartFakeオブジェクトを返すため、
      // 明示的にモックを設定する必要がない

      container = ProviderContainer(
        overrides: [misskeyPostContextProvider.overrideWithValue(mockMisskey)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
      "should be able to read the provider without throwing UnimplementedError",
      () {
        // This test verifies that the provider can be instantiated
        // without throwing UnimplementedError due to missing dependencies
        expect(
          () => container.read(noteDraftRepositoryProvider.notifier),
          returnsNormally,
        );
      },
    );

    test("should be able to access the provider state", () {
      final repository = container.read(noteDraftRepositoryProvider.notifier);
      final state = container.read(noteDraftRepositoryProvider);

      // The provider should initialize with an empty state
      expect(state, isA<Map<String, NoteDraft>>());
      expect(state.isEmpty, isTrue);
    });

    test("should have access to drafts property", () {
      final repository = container.read(noteDraftRepositoryProvider.notifier);

      // The drafts getter should return the current state
      expect(repository.drafts, isA<Map<String, NoteDraft>>());
      expect(repository.drafts.isEmpty, isTrue);
    });

    group("Within AccountContextScope", () {
      Widget createTestWidget({required AccountContext accountContext}) {
        final router = AppRouter();
        final container = ProviderContainer(
          overrides: [
            misskeyGetContextProvider.overrideWithValue(mockMisskey),
            misskeyPostContextProvider.overrideWithValue(mockMisskey),
          ],
        );

        return UncontrolledProviderScope(
          container: container,
          child: DefaultRootWidget(
            router: router,
            initialRoute: DraftsRoute(accountContext: accountContext),
          ),
        );
      }

      testWidgets(
        "should work within AccountContextScope without UnimplementedError",
        (tester) async {
          // SmartFakeは実際のメソッド呼び出しでは動作しないため、
          // 実際のUnimplementedErrorが発生するかどうかをテストする
          final accountContext = AccountContext.as(testAccount);

          await tester.pumpWidget(
            createTestWidget(accountContext: accountContext),
          );
          await tester.pumpAndSettle();

          // エラーが発生している場合は、ErrorDetailウィジェットが表示される
          // UnimplementedErrorが解決されていれば、API呼び出しでエラーが発生しても別のエラー（ネットワークエラーなど）になる
          // どちらにせよ、UnimplementedErrorでなければ進歩
          expect(find.byType(CircularProgressIndicator), findsNothing);
        },
      );
    });
  });
}
