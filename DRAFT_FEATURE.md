# ノート下書き機能

このファイルは下書き機能の実装を開始するための初期マーカーです。

## 実装計画

### 1. misskey_dartへのAPI対応追加
- NoteDraft関連のAPIエンドポイント定義
- JSON serialization対応

### 2. データモデルとRepository
- NoteDraft, NoteDraftRepository実装
- Riverpodプロバイダー作成

### 3. UI実装
- PopScopeを使った戻る時のダイアログ
- 下書き一覧画面
- 既存ノート作成画面への統合

### 4. テスト
- 各機能のテストコード作成