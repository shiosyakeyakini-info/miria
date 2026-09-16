import "package:miria/rust/frb_generated.dart";

/// Rust 側の初期化が済んでいるか。
///
/// 済んだかどうかを [Future] ではなく真偽値で覚えるのが要点。Future を
/// 使い回すと、それを作ったゾーンの外から待ったときに永久に返らない
/// (ウィジェットテストは1件ごとに別ゾーンで走るため、2件目以降が固まる)。
bool _isRustInitialized = false;
Future<void>? _rustInitialization;

/// Rust 側の関数を呼ぶ前に呼ぶ。二度目以降は何もしない。
Future<void> ensureRustInitialized() async {
  if (_isRustInitialized) return;
  await (_rustInitialization ??= RustLib.init());
  _isRustInitialized = true;
}
