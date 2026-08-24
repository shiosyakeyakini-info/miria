import "package:flutter_test/flutter_test.dart";
import "package:miria/rust/api/aiscript.dart";
import "package:miria/rust/frb_generated.dart";

/// Rust 側の AiScript 処理系が Dart から呼べているかを確かめる。
///
/// 処理系そのもののテストは aiscript-rs 側に揃っているので、ここでは
/// flutter_rust_bridge の配線が生きていることだけを見る。
///
/// なお `flutter test` は native assets を FFI に解決しないため、frb の
/// フォールバック先である `rust/target/release/` に共有ライブラリが必要。
/// 事前に `cargo build --release --manifest-path rust/Cargo.toml` を実行する。
void main() {
  setUpAll(() async => RustLib.init());

  test("組み込んでいる AiScript のバージョンが取得できること", () async {
    expect(await aiscriptVersion(), matches(RegExp(r"^\d+\.\d+\.\d+")));
  });

  test("文字列が出力されること", () async {
    expect(await eval(input: "<: 'Hello, world!'"), ["Hello, world!"]);
  });

  test("式が評価されること", () async {
    expect(await eval(input: "<: (1 + 2) * 3"), ["9"]);
  });

  test("繰り返しの出力が順に返ること", () async {
    expect(await eval(input: "for (let i, 3) { <: i }"), ["0", "1", "2"]);
  });

  test("配列と真偽値が表示用に整形されること", () async {
    expect(await eval(input: "<: [1, 2]"), ["[ 1, 2 ]"]);
    expect(await eval(input: "<: true"), ["true"]);
  });

  test("構文エラーが例外として伝わること", () async {
    // Rust 側の Err(String) はそのまま String として投げられる
    await expectLater(eval(input: "<: ("), throwsA(isA<String>()));
  });
}
