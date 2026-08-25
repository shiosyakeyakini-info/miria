# 手元にMisskeyを立てる

AiScript（Play・スクラッチパッド・プラグイン）が実際のサーバー相手に動くかを
確かめるための手順。`assets_builder/misskey` のサブモジュールをそのまま使う。

モックではなく本物を相手にすると、`Mk:api` の配線、`USER_ID` などの定数、
プラグインが投稿を立てられるかまで一度に見られる。

## 要るもの

- Node.js 22 以降と pnpm（Misskeyの `packageManager` は pnpm 10）
- PostgreSQL 16
- Redis 7

## 立てる

```bash
git submodule update --init --depth 1 assets_builder/misskey
cd assets_builder/misskey
```

### 1. PostgreSQLとRedis

```bash
pg_ctlcluster 16 main start
sudo -u postgres psql -c "CREATE ROLE misskey WITH LOGIN PASSWORD 'misskey' CREATEDB;"
sudo -u postgres createdb -O misskey misskey_db

redis-server --daemonize yes --port 6379 --bind 127.0.0.1 --save ""
```

### 2. 設定

`.config/default.yml` を置く。

```yaml
url: http://localhost:3000/
port: 3000
db:
  host: 127.0.0.1
  port: 5432
  db: misskey_db
  user: misskey
  pass: misskey
dbReplications: false
redis:
  host: 127.0.0.1
  port: 6379
fulltextSearch:
  provider: sqlLike
id: 'aidx'
```

### 3. 依存とビルド

**バックエンドだけ**入れる。miriaが相手にするのはAPIだけなので、フロント
エンドは要らない。

```bash
CYPRESS_INSTALL_BINARY=0 pnpm install --frozen-lockfile --filter "backend..."
pnpm build-pre && pnpm --filter "backend..." build
pnpm migrate
pnpm start
```

`http://localhost:3000` で上がる。Web UIは出ないが、APIは全部応える。

#### 引っかかりどころ

- **フロントエンドを含めると `pnpm install` が落ちる。** `aiscript-vscode` を
  `codeload.github.com` から取りに行くが、閉じたネットワークでは弾かれる
  ことがある。`--filter "backend..."` で回避できる（この依存はWebの
  コードエディタの構文強調用で、APIには関係ない）
- **Cypressのバイナリ取得で落ちる。** テスト専用なので
  `CYPRESS_INSTALL_BINARY=0` で止めてよい

### 4. アカウントを作る

最初の1人は認証なしで作れる。

```bash
curl -s -X POST http://127.0.0.1:3000/api/admin/accounts/create \
  -H 'content-type: application/json' \
  -d '{"username":"miria","password":"miria-test-password"}'
```

返ってくる `token` を控える。

## miriaから叩く

`test/rust/aiscript_live_server_test.dart` が実サーバー向けのテスト。
トークンを環境変数で渡すと動き、渡さなければ丸ごと飛ぶ（CIでは何もしない）。

```bash
cargo build --release --manifest-path rust/Cargo.toml
MISSKEY_TEST_TOKEN=<控えたトークン> fvm flutter test test/rust/aiscript_live_server_test.dart
```

繋ぎ先は `MISSKEY_TEST_HOST`（既定 localhost）と `MISSKEY_TEST_PORT`
（既定 3000）で変えられる。

## アプリから繋ぐ

`flutter run` して、ログイン画面でサーバーに `localhost:3000` を入れる。
`http` なので、miriaは `Account.scheme` に `http` を持つ。実機（特にiOS）から
繋ぐ場合は、`localhost` ではなく開発機のIPを `url` に書いてサーバーを
立て直すこと。
