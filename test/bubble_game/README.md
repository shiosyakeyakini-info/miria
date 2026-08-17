# バブルゲームの参照トレース

`reference_traces.json`は、Misskey本家のバブルゲーム
(`packages/misskey-bubble-game`) をNode.jsで実際に動かして取った実行結果です。
`drop_and_fusion_game_test.dart`はこれと移植版の結果が
**完全に一致する**ことを確認します。

バブルゲームはスコアをシード・操作ログと一緒に`bubble-game/register`へ送るため、
「だいたい同じ挙動」では足りず、同じ操作から同じ盤面・同じスコアになる必要があります。

## 中身

| キー | 内容 |
| --- | --- |
| `mode` / `seed` / `frames` / `ops` | 再現するための入力 |
| `result.snapshots` | 300フレームごと + 最終フレームの全ボディの位置・角度 |
| `result.events` | 合体・スコア・コンボ・ゲームオーバーの発生フレーム |
| `result.logs` | サーバーに送る形式に直列化した操作ログ |

`events`のコンボは毎フレーム0で通知されるため、値が変わったときだけ記録しています。

## 作り直しかた

サブモジュールに本家のソースが必要です。

```bash
git submodule update --init --depth 1 assets_builder/misskey
```

作業用ディレクトリを作り、本家と同じバージョンの依存を入れます。

```bash
mkdir -p /tmp/bubble-ref && cd /tmp/bubble-ref
npm install matter-js@0.20.0 seedrandom@3.0.5 eventemitter3@5.0.1 esbuild@0.25.9
```

`harness.ts`として本家の`DropAndFusionGame`を動かすスクリプトを置き、
`esbuild`でバンドルして実行します
(`NODE_PATH`を指定しないと本家のソースから依存を解決できません)。

```bash
NODE_PATH=/tmp/bubble-ref/node_modules npx esbuild harness.ts \
  --bundle --platform=node --format=esm --outfile=harness.mjs
SNAP=300 node harness.mjs <mode> <seed> <frames> '<ops>'
```

`getMonoRenderOptions`を渡さないと本家の`Body.create`が落ちるので、
`() => ({})`を渡してください (描画用の値なので物理には影響しません)。

移植版との突き合わせは次のコマンドでも実行できます。

```bash
fvm dart run tool/bubble_game_compare.dart test/bubble_game/reference_traces.json
```
