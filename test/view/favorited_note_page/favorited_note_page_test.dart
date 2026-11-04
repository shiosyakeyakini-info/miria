import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";
import "../../test_util/widget_tester_extension.dart";

void main() {
  group("お気に入り一覧", () {
    late MockMisskey misskey;
    late MockMisskeyI i;

    // aidxは「2000年からの経過ミリ秒のbase36 8桁 + 個体ID 4桁 + カウンタ 4桁」。
    // 先頭8桁が時刻なので、そこから生成時刻を復元できる。
    DateTime aidxCreatedAt(String id) => DateTime.fromMillisecondsSinceEpoch(
      int.parse(id.substring(0, 8), radix: 36) +
          DateTime.utc(2000).millisecondsSinceEpoch,
      isUtc: true,
    );

    IFavoritesResponse favorite({required String id, required String noteId}) =>
        IFavoritesResponse(
          id: id,
          createdAt: aidxCreatedAt(id),
          noteId: noteId,
          note: TestData.note1.copyWith(
            id: noteId,
            createdAt: aidxCreatedAt(noteId),
          ),
        );

    // お気に入りレコードのIDはお気に入りした時刻由来、ノートIDは投稿時刻由来で、
    // どちらもaidxだが値域がまったく異なる。
    // ここでは「1年以上前のノートを今日お気に入りした」という、取り違えたときに
    // いちばん影響が出る状況を再現する。ノートIDはお気に入りIDより必ず小さいので、
    // ノートIDをカーソルに渡すと2ページ目が空になる。
    // 一覧はお気に入りIDの降順で返るため、2ページ目のカーソルは1ページ目末尾の
    // 最小のID。投稿時刻の順とは無関係であることも込みで、ノートは昇順にしてある。
    final favorite1 = favorite(
      id: "arnbz4007p2x0003", // お気に入り: 2026-09-27T12:00:00Z
      noteId: "9qvzstc03k9m0007", // 投稿: 2024-03-15T09:00:00Z
    );
    final favorite2 = favorite(
      id: "arn9ty807p2x0002", // お気に入り: 2026-09-27T11:00:00Z
      noteId: "a042bgw03k9m0015", // 投稿: 2024-11-02T18:30:00Z
    );
    final favorite3 = favorite(
      id: "arn7osg07p2x0001", // お気に入り: 2026-09-27T10:00:00Z
      noteId: "a38b2ag03k9m0036", // 投稿: 2025-01-20T07:45:00Z
    );

    setUp(() {
      misskey = MockMisskey();
      i = MockMisskeyI();
      when(misskey.i).thenReturn(i);
    });

    Widget buildWidget() => ProviderScope(
      overrides: [
        misskeyProvider.overrideWith((ref, account) => misskey),
        cacheManagerProvider.overrideWith((ref) => MockCacheManager()),
      ],
      child: DefaultRootWidget(
        initialRoute: FavoritedNoteRoute(
          accountContext: TestData.accountContext,
        ),
      ),
    );

    testWidgets("お気に入りしたノートが表示されること", (tester) async {
      when(
        i.favorites(any),
      ).thenAnswer((_) async => const <IFavoritesResponse>[]);
      when(
        i.favorites(const IFavoritesRequest()),
      ).thenAnswer((_) async => [favorite1, favorite2]);

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(PushableListView<IFavoritesResponse>), findsOneWidget);
      expect(find.byType(MisskeyNote), findsNWidgets(2));
    });

    // untilIdのカーソルはお気に入りレコードのIDで、ノートIDを渡すと
    // 2ページ目が空になる・大きく飛ぶ・重複する
    testWidgets("「さらに読み込む」でお気に入りIDをuntilIdに渡すこと", (tester) async {
      // 具体的なstubが後勝ちになるよう、先に既定を置く
      when(
        i.favorites(any),
      ).thenAnswer((_) async => const <IFavoritesResponse>[]);
      when(
        i.favorites(const IFavoritesRequest()),
      ).thenAnswer((_) async => [favorite1, favorite2]);
      when(
        i.favorites(IFavoritesRequest(untilId: favorite2.id)),
      ).thenAnswer((_) async => [favorite3]);

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(MisskeyNote), findsNWidgets(2));

      await tester.pageNation();

      // 2ページ目のぶんが足されていること
      expect(find.byType(MisskeyNote), findsNWidgets(3));
      // ノートIDを渡していた場合はuntilIdがノートのaidxになり、この検証が落ちる
      verify(i.favorites(IFavoritesRequest(untilId: favorite2.id))).called(1);
    });
  });
}
