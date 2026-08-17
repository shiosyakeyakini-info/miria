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

## 実サーバーに対する確認

`register_e2e_test.dart`は、実際に立てたMisskeyへスコアを送って
`bubble-game/register`が通ること、送ったスコアが`bubble-game/ranking`に
載ることを確認します。環境変数が無いときはスキップされます。

```bash
MISSKEY_HOST=localhost:3000 MISSKEY_TOKEN=<アクセストークン> \
  fvm flutter test test/bubble_game/register_e2e_test.dart
```

モノの画像がサーバーの`/client-assets/`と食い違っていないかも確認できます
(こちらはトークンが要りません)。

```bash
MISSKEY_HOST=localhost:3000 \
  fvm flutter test test/bubble_game/mono_textures_e2e_test.dart
```

`MISSKEY_SCHEME`は既定で`http`です。

スコアの登録は30秒に1回までというサーバー側の制限があり、これは
`NODE_ENV=production`のときだけ効きます。本番モードのサーバーに対して流すと
待ち時間が入るので、5モードぶんで3分ほどかかります。

### サーバーの立てかた

PostgreSQLとRedisを用意してから、サブモジュールの本家をビルドします。
フロントエンドはAPIの確認には要らないので、バックエンドだけ入れれば十分です
(フロントエンドの依存にはGitHubから取るものがあり、環境によっては落ちます)。

```bash
git submodule update --init --depth 1 assets_builder/misskey
cd assets_builder/misskey

# 依存の取得とビルド (バックエンドのみ)
CYPRESS_INSTALL_BINARY=0 pnpm install --frozen-lockfile --filter backend...
pnpm build-pre
pnpm --filter misskey-js --filter misskey-reversi --filter backend build
```

`.config/default.yml`を用意します。

```yaml
url: http://localhost:3000/
port: 3000
db:
  host: 127.0.0.1
  port: 5432
  db: misskey
  user: misskey
  pass: misskey
dbReplications: false
redis:
  host: 127.0.0.1
  port: 6379
id: 'aidx'
```

```bash
pnpm --filter backend migrate
NODE_ENV=development node packages/backend/built/boot/entry.js
# レート制限まで含めて確かめたいときは NODE_ENV=production で起動する
```

初回のアカウントはAPIから作れます。返ってくる`token`をそのまま使えます。

```bash
curl -s http://localhost:3000/api/admin/accounts/create \
  -H 'Content-Type: application/json' \
  -d '{"username":"miria","password":"<password>"}'
```
