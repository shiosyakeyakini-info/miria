import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/aiscript_plugin_notifier.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../test_util/mock.mocks.dart";
import "../test_util/test_datas.dart";

/// プラグインの note_view_interruptor がノートに掛かること。
///
/// 本家 Misskey は描画のたびに同期で通すが、AiScript が Rust 側にある miria
/// では同期に呼べない。ノートが入ってきた時点で通して、結果を持っておく形に
/// した。表示は一度もとのまま出て、通し終えてから差し替わる。
///
/// AiScript は Rust 側で動くため、`flutter test` からは
/// `rust/target/release/` の共有ライブラリが要る。事前に
/// `cargo build --release --manifest-path rust/Cargo.toml` を実行する。
void main() {
  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final mockMisskey = MockMisskey();
    when(
      mockMisskey.emojis(),
    ).thenAnswer((_) async => const EmojisResponse(emojis: []));
    container = ProviderContainer(
      overrides: [misskeyProvider.overrideWith((ref, account) => mockMisskey)],
    );
    addTearDown(container.dispose);
  });

  /// note_view_interruptor を持つプラグインを入れる。
  Future<void> installInterruptor(String body) async {
    await container
        .read(aiScriptPluginProvider(TestData.account).notifier)
        .install("""
        /// @ 0.19.0
        ### {
          name: "書き換え"
          version: "1.0.0"
          author: "みりあ"
        }
        Plugin:register:note_view_interruptor(@(note) {
          $body
          return note
        })
        """, locale: "ja-JP");
  }

  /// 差し替えが済むまで待つ。
  Future<void> settle() async {
    for (var i = 0; i < 40; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 25));
    }
  }

  test("プラグインを入れていなければノートはそのままであること", () async {
    final notes = container.read(notesProvider(TestData.account))
      ..registerNote(TestData.note1);
    await settle();

    expect(notes.notes[TestData.note1.id]?.text, TestData.note1.text);
  });

  test("interruptor がノートの本文を書き換えること", () async {
    await installInterruptor("""note.text = "書き換えた" """);

    final notes = container.read(notesProvider(TestData.account))
      ..registerNote(TestData.note1);

    // 通し終えるまでは、もとのノートがそのまま出ている
    expect(notes.notes[TestData.note1.id]?.text, TestData.note1.text);

    await settle();

    expect(notes.notes[TestData.note1.id]?.text, "書き換えた");
  });

  test("ノートが先に入っていても、あとから入れたプラグインが次から掛かること", () async {
    // アプリの起動直後はこの順になる。タイムラインが先に流れてきて、
    // プラグインの立ち上げはその後ろに回ることがある
    final notes = container.read(notesProvider(TestData.account))
      ..registerNote(TestData.note1);
    await settle();
    expect(notes.notes[TestData.note1.id]?.text, TestData.note1.text);

    await installInterruptor("""note.text = "あとから掛かった" """);

    // 読み直しで同じノートが入り直したら、今度は通る
    notes.registerNote(TestData.note1);
    await settle();

    expect(notes.notes[TestData.note1.id]?.text, "あとから掛かった");
  });

  test("プラグインが変なものを返してもノートが消えないこと", () async {
    await container
        .read(aiScriptPluginProvider(TestData.account).notifier)
        .install("""
        /// @ 0.19.0
        ### {
          name: "こわれもの"
          version: "1.0.0"
          author: "みりあ"
        }
        Plugin:register:note_view_interruptor(@(note) {
          return "ノートではない"
        })
        """, locale: "ja-JP");

    final notes = container.read(notesProvider(TestData.account))
      ..registerNote(TestData.note1);
    await settle();

    expect(notes.notes[TestData.note1.id]?.text, TestData.note1.text);
  });
}
