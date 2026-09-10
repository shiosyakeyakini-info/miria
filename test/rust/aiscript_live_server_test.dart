import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/repository/aiscript_storage_repository.dart";
import "package:miria/state_notifier/aiscript_plugin_notifier.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/play_page/create_aiscript.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:shared_preferences/shared_preferences.dart";

/// 実際に動いている Misskey に対して AiScript を走らせる。
///
/// モックではなく本物のサーバーを相手にするので、`Mk:api` の配線や
/// USER_ID などの定数が実際に噛み合っているかがここで分かる。
///
/// サーバーは `assets_builder/misskey` から立てる。手順は
/// `docs/local-misskey.md` にある。立っていなければこのファイルは丸ごと
/// 飛ばすので、CI では何もしない。
///
/// 環境変数で繋ぎ先とトークンを渡す。
/// - `MISSKEY_TEST_HOST` (既定 localhost)
/// - `MISSKEY_TEST_PORT` (既定 3000)
/// - `MISSKEY_TEST_TOKEN` (必須)
void main() {
  final host = Platform.environment["MISSKEY_TEST_HOST"] ?? "localhost";
  final port =
      int.tryParse(Platform.environment["MISSKEY_TEST_PORT"] ?? "") ?? 3000;
  final token = Platform.environment["MISSKEY_TEST_TOKEN"];

  if (token == null || token.isEmpty) {
    // トークンがなければ検証しようがないので、まるごと飛ばす
    return;
  }

  late Account account;
  late Misskey misskey;
  late ProviderContainer container;

  setUpAll(() async {
    misskey = Misskey(
      token: token,
      host: "$host:$port",
      apiUrl: "http://$host:$port/api/",
      streamingUrl: "ws://$host:$port/streaming/",
    );
    final me = await misskey.i.i();
    account = Account(
      host: host,
      port: port,
      scheme: "http",
      userId: me.username,
      token: token,
      i: me,
    );
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  /// 実サーバーに繋いだ AiScript を作って走らせ、出力を返す。
  Future<List<String>> run(String script) async {
    final output = <String>[];
    final aiscript = await createAiScript(
      misskey: misskey,
      account: account,
      storage: const AiScriptStorageRepository(namespace: "test"),
      dialogs: container.read(dialogStateProvider.notifier),
      locale: "ja-JP",
      write: output.add,
    );
    await aiscript.exec(input: script);
    return output;
  }

  test("USER_ID と USER_USERNAME が実際のアカウントと一致すること", () async {
    expect(await run("<: [USER_ID, USER_USERNAME]"), [
      '[ "${account.i.id}", "${account.i.username}" ]',
    ]);
  });

  test("SERVER_URL が繋ぎ先を指していること", () async {
    expect(await run("<: SERVER_URL"), ["http://$host:$port"]);
  });

  test("Mk:api でタイムラインが読めること", () async {
    final output = await run("""
      let notes = Mk:api("notes/local-timeline", { limit: 3 })
      <: notes.len > 0
      <: Core:type(notes[0].id)
      """);

    expect(output, ["true", "str"]);
  });

  test("Mk:api でノートが投稿でき、サーバーに残ること", () async {
    final marker = "AiScript実サーバー検証 ${DateTime.now().microsecondsSinceEpoch}";
    final output = await run("""
      let created = Mk:api("notes/create", { text: "$marker" })
      <: created.createdNote.id
      """);

    expect(output, hasLength(1));
    final noteId = output.single;

    // AiScript の外から、本当に立っているか確かめる
    final note = await misskey.notes.show(NotesShowRequest(noteId: noteId));
    expect(note.text, marker);
  });

  test("Mk:api の失敗が AiScript のエラーとして返ること", () async {
    final output = await run("""
      let result = Mk:api("notes/show", { noteId: "存在しないID" })
      <: Core:type(result)
      """);

    expect(output, ["error"]);
  });

  test("Mk:save と Mk:load が往復すること", () async {
    expect(
      await run("""
      Mk:save("key", { a: 1, b: "に" })
      let loaded = Mk:load("key")
      <: [loaded.a, loaded.b]
      """),
      ['[ 1, "に" ]'],
    );
  });

  test("Mk:nyaize が本家と同じ結果を返すこと", () async {
    expect(await run("""<: Mk:nyaize("こんばんは、みんな")"""), ["こんばんは、みんにゃ"]);
  });

  test("CUSTOM_EMOJIS が配列として渡ること", () async {
    expect(await run("<: Core:type(CUSTOM_EMOJIS)"), ["arr"]);
  });

  test("プラグインの note_action から Mk:api でノートが投稿できること", () async {
    final marker = "プラグイン実サーバー検証 ${DateTime.now().microsecondsSinceEpoch}";
    final notifier = container.read(aiScriptPluginProvider(account).notifier);

    await notifier.install("""
      /// @ 0.19.0
      ### {
        name: "実サーバー検証"
        version: "1.0.0"
        author: "みりあ"
      }
      Plugin:register:note_action("引用して投稿", @(note) {
        let created = Mk:api("notes/create", { text: `$marker {note.id}` })
        <: created.createdNote.id
      })
      """, locale: "ja-JP");

    final action = container.read(aiScriptPluginProvider(account)).noteActions;
    expect(action, hasLength(1));
    expect(action.single.title, "引用して投稿");

    // 本物のノートをハンドラに渡す
    final notes = await misskey.notes.localTimeline(
      const NotesLocalTimelineRequest(limit: 1),
    );
    final target = notes.first;
    await action.single.callback.call(value: jsonEncode(target.toJson()));

    // ハンドラの `<:` はプラグインのログに落ちる。そこから id を拾って、
    // サーバーに投稿が立っているかを外から確かめる
    final installId = container
        .read(aiScriptPluginProvider(account))
        .plugins
        .single
        .installId;
    final logs = container
        .read(aiScriptPluginProvider(account))
        .logs[installId];
    expect(logs, hasLength(1));

    final posted = await misskey.notes.show(
      NotesShowRequest(noteId: logs!.single),
    );
    expect(posted.text, "$marker ${target.id}");
  });

  test("プラグインの note_view_interruptor に実物のノートを通せること", () async {
    // サーバーから取った本物のノートを JSON にして通す
    final notes = await misskey.notes.localTimeline(
      const NotesLocalTimelineRequest(limit: 1),
    );
    expect(notes, isNotEmpty);

    final output = await run("""
      let note = ${jsonEncode(notes.first.toJson())}
      <: Core:type(note.id)
      """);
    expect(output, ["str"]);
  });
}
