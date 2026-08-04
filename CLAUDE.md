# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

MiriaはFlutterで開発されたMisskeyクライアントアプリです。iOS、Android、デスクトップ（Windows、macOS、Linux）をサポートしています。

## 開発コマンド

### 基本的な開発コマンド
```bash
# 依存関係の取得
fvm flutter pub get

# 開発モードで実行
fvm flutter run

# コード生成
fvm flutter pub run build_runner build

# テスト実行（カバレッジ付き）
fvm flutter test --coverage --coverage-path=~/coverage/lcov.info

# コードフォーマット
fvm dart format --output=none --set-exit-if-changed .
```

### ビルドコマンド
```bash
# iOS (リリース)
fvm flutter build ipa --no-tree-shake-icons --release --no-codesign

# Android APK
fvm flutter build apk --no-tree-shake-icons --release

# Android AAB
fvm flutter build appbundle --no-tree-shake-icons --release

# Windows
fvm flutter build windows --release

# Linux
fvm flutter build linux
```

### その他のコマンド
```bash
# アイコン生成
fvm flutter pub run flutter_launcher_icons:main

# バージョンアップ
fvm flutter pub run cider bump build --bump-build

# バージョン確認
fvm flutter pub run cider version
```

### 実行中アプリの観測・操作（marionette MCP）

debug ビルドには [marionette_mcp](https://github.com/leancodepl/marionette_mcp)
の binding が組み込まれており、AI エージェントから実行中のアプリを直接
操作・観測できる。実装は `lib/marionette_debug.dart`（release では
`kDebugMode` ガードで丸ごと無効化される）。

```bash
dart pub global activate marionette_mcp   # 初回のみ
fvm flutter run                           # コンソールの VM Service URI を控える
```

`.mcp.json` に `marionette` サーバーを定義済み。エージェントに上記 URI を
渡して接続させると、以下が使えるようになる。

| ツール | 用途 |
|---|---|
| `get_interactive_elements` | ウィジェットツリー（トークン節約版） |
| `tap` / `enter_text` / `scroll_to` | 画面操作 |
| `take_screenshots` | スクリーンショット |
| `get_logs` | `lib/log.dart` の `logger` 出力 |
| `riverpod_snapshot` | 生きている Provider と値の一覧 |
| `riverpod_read` | Provider 1 個の値を深く見る |

`riverpod_snapshot` / `riverpod_read` は
[marionette_riverpod_plugin](https://github.com/shiosyakeyakini-info/marionette_riverpod_plugin)
が提供する。まだ一度も read されていない
Provider は Riverpod の遅延生成の仕様上スナップショットに現れない。
まず `includeValues=false` で一覧を取り、目的の Provider を `riverpod_read`
で掘るのが効率的。詳細はプラグインの README を参照。

実際に操作する手順（ログイン、ノート投稿、要素の探し方、Windows ビルドの
ツールセット固定など）は `.claude/skills/drive-miria/` にスキルとしてまとめて
ある。MCP サーバーを立てずに済ませたい場合の
`scripts/marionette.py` も同梱している。

### リバーシ（実証実験）

Misskey のリバーシをアプリ内で遊べるようにしたもの。ルールエンジンは本家
`packages/misskey-reversi` を Dart に移植してある（`lib/model/reversi/`）。

移植が要るのは見た目の都合ではない。サーバーは対局が始まったあと盤面を
一度も送ってこず、`reversiGame` チャンネルに「誰がどこに打ったか」の `log`
イベントしか流さない。盤面はクライアントが自前で再現するしかなく、実装が
1 箇所でもずれると `reversi/verify` の CRC32 が合わなくなる。

| ファイル | 中身 |
|---|---|
| `lib/model/reversi/reversi_game.dart` | ルールエンジン（`game.ts` の移植） |
| `lib/model/reversi/reversi_maps.dart` | 40 種類のマップ（`maps.ts` の移植） |
| `lib/model/reversi/reversi_serializer.dart` | 対局ログの復元（`serializer.ts` の移植） |
| `lib/state_notifier/reversi/` | マッチングと対局の状態 |
| `lib/view/games_page/reversi/` | マッチング画面・対局画面・盤面 |

移植の正しさは `test/model/reversi/reversi_golden_test.dart` が見ている。
本家の TypeScript を実際に走らせて作った棋譜
（41 マップ × 5 ルール設定 = 205 局、10918 手）と、1 手ごとに盤面・手番・
CRC32 まで突き合わせる。照合データの作り直しは
`test/assets/reversi_golden_gen.js` を参照。

#### e2e の回し方

marionette から動かせるのは miria 1 つだけなので、対戦相手は別に用意する。

```bash
# 相手役。招待を出し、マッチしたら自動で打ち返す
fvm dart run tool/reversi_bot.dart --token <相手のトークン> --target miria

# 盤面の確認（Riverpod の状態が読めないときの代替、下記参照）
fvm dart run tool/reversi_show.dart --token <トークン> --game <gameId>
```

miria 側は `Misskey Games → リバーシ` から招待に応じ、`reversi-ready` を押し、
`reversi-cell-<pos>` をタップして打つ。盤面のマスは 1 つずつ Key を持たせて
あるので、座標を数えずに指定できる。

盤面の状態は `riverpod_read` からも読める。`ReversiGameState.toJson` が
盤面・手番・着手可能マス・crc32 を出すので、e2e のアサーションはこれを見る
のがいちばん確実（マス目はウィジェットツリー上ではただの矩形で、盤面の
中身が読めない）。

対局画面は `AccountContextScope` が挟む子 `ProviderScope` の下にあるため、
以前は root コンテナしか見ない marionette_riverpod_plugin から見えなかった。
プラグイン側が入れ子の `ProviderScope` を辿るようになったので今は見える。
スコープ内の provider は id に `#scopeN` が付く。

```bash
m snapshot --filter reversi   # scopes が 1 より大きければスコープが効いている
m read 'reversiGameProvider(<gameId>)#scope1'
```

`tool/reversi_show.dart` はサーバー側から同じ盤面を組み直すので、アプリの
盤面が正しいかを外から突き合わせたいときに使う。

## アーキテクチャ

### 状態管理
- **Riverpod 3.0 (dev版)** を使用
- `@Riverpod`アノテーションによるcode generation
- `providers.dart`で中央集権的な依存性注入管理
- マルチアカウント対応のため`AccountContext`パターンを使用

### データレイヤー
- **Repository パターン**: `lib/repository/`配下でAPI呼び出しとローカル状態を管理
- **Freezed + json_annotation**: 全データモデルでimmutableクラスとJSON serialization
- **misskey_dart**: Misskey APIクライアント

### UIレイヤー
- **auto_route**: ルーティング管理（`app_router.dart`）
- **flutter_hooks**: React Hooksライクなウィジェット
- カスタムタイムラインUI（双方向無限スクロール対応）

### 主要な設計パターン
- **AccountContext**: 読み取り用・投稿用アカウントの分離
- **TimelineRepository**: 各種タイムライン（Home、Local、Global等）の基底クラス
- **MFMサポート**: Misskeyの独自マークアップ言語の完全サポート

## 重要な開発規則

### コード生成
新しいデータモデルやプロバイダーを追加した場合は、必ず以下を実行：
```bash
fvm flutter pub run build_runner build
```

### ルーティング
新しい画面を追加する場合：
1. `app_router.dart`にルートを追加
2. 適切なルートタイプを選択（AutoRoute、AutoDialogRoute、AutoModalRouteSheet）
3. コード生成を実行

### 状態管理
- 新機能は`@riverpod`アノテーションを使用
- 既存のChangeNotifierProviderは段階的に移行中
- マルチアカウント対応のため、必ずAccountContextを考慮

### データモデル
- 新しいモデルは必ずFreezedを使用
- JSON serialization/deserializationを考慮
- immutableな設計を維持

## プロジェクト固有事項

- **FVM使用**: Flutter 3.24.5で固定（`.fvmrc`）
- **国際化対応**: `l10n.yaml`設定、現在は日本語（規定は関西弁、ja_OJはお嬢様口調）・中国語をサポート
- **マルチプラットフォーム**: モバイル・デスクトップの両方をサポート
- **Misskeyバージョン**: v13以降のMisskey及びforkをサポート

### 最後に必ずやること

- `fvm dart analyze | grep 'error'`で致命的なエラーが出ていないかを確認する
- `fvm dart format .`でフォーマッタを適用する
- `fvm dart fix --apply`で機械的に修正可能なフォーマットを修正する
- `fvm flutter test`でテストが動作することを確認する　（やや長い時間がかかります）