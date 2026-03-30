import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:integration_test/integration_test.dart";
import "package:miria/main.dart";
import "package:misskey_dart/misskey_dart.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const misskeyHost = "localhost:3000";
  const misskeyToken = String.fromEnvironment(
    "MISSKEY_TOKEN",
    defaultValue: "peGRXoAtO1rYvsWB",
  );

  testWidgets("app starts successfully", (tester) async {
    await tester.pumpWidget(const ProviderScope(child: Miria()));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(ProviderScope), findsOneWidget);
  });

  testWidgets("can connect to local Misskey instance", (tester) async {
    final misskey = Misskey(
      host: misskeyHost,
      token: misskeyToken,
      apiUrl: "http://$misskeyHost/api/",
      streamingUrl: "ws://$misskeyHost/streaming/",
    );

    // サーバーにpingを送信
    final pong = await misskey.ping();
    expect(pong, isNotNull);

    // 自分のアカウント情報を取得
    final me = await misskey.i.i();
    expect(me.username, equals("admin"));
    expect(me.isAdmin, isTrue);

    // ノートを作成
    await misskey.notes.create(
      NotesCreateRequest(text: "Integration test note"),
    );

    // タイムラインを取得してノートが存在することを確認
    final timeline = await misskey.notes.localTimeline(
      const NotesLocalTimelineRequest(),
    );
    expect(timeline, isNotEmpty);
    expect(timeline.first.text, equals("Integration test note"));

    // 後片付け: 作成したノートを削除
    await misskey.notes.delete(NotesDeleteRequest(noteId: timeline.first.id));

    // pumpWidgetが必要（IntegrationTestの制約）
    await tester.pumpWidget(const ProviderScope(child: Miria()));
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
