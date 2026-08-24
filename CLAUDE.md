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

### Misskey由来のアセット（assets_builder）

Misskey本体にしかないデータは `assets_builder/` のスクリプトで `assets/` に
取り込む。サブモジュール `assets_builder/misskey` を要求するものがある。

```bash
git submodule update --init --depth 1 assets_builder/misskey
```

| ビルダー | 出力 | 中身 | サブモジュール |
|---|---|---|---|
| `emoji_list/builder.mjs` | `assets/emoji_list.json` | Unicode絵文字と読みがな | 任意 |
| `achievements/builder.mjs` | `assets/achievements.json` | 実績名の対訳 | 必須 |
| `theme_list/builder.mjs` | （つくりかけ） | テーマ | 必須 |

Unicode絵文字のデータはMisskey本体から
[@misskey-dev/emoji-data](https://github.com/misskey-dev/emojis) に切り出されて
いるので、絵文字ビルダーはnpmパッケージを引く。バージョンは本家の
`packages/frontend-shared/package.json` の pin に合わせること。サブモジュールが
あればビルダーがつきあわせて、ずれていれば警告する。

```bash
cd assets_builder/emoji_list && npm install && node builder.mjs
```

絵文字を増やしても、`flutter_twemoji` の絵文字正規表現が古いままだと
「絵文字のスタイル」が既定（Twemoji）のときに描画されず、ノート本文からも
リアクションピッカーからも消える（読みがなでは引けるが押しても見えない）。
`assets/emoji_list.json` を更新したら
`Twemoji` の描画も確かめること。

実績はサーバーが `notes1` のような名前しか寄越さず、対訳はMisskeyの
`locales/*.yml` の `_achievements._types` にしかない。ビルダーはそこだけを
`locales/index.js` と同じフォールバック規則で解決して書き出す。

```bash
cd assets_builder/achievements && npm install && node builder.mjs
```

引くのは `lib/model/achievement.dart` の `Achievements`。表示言語との対応は
同ファイルにあり、miriaの日本語は関西弁が規定なのでMisskeyの **ja-KS** を、
お嬢様言葉はMisskeyに相当するロケールがないので ja-JP を引く。Misskey側で
実績が増えたら対訳がないので、実績名がそのまま出る。

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