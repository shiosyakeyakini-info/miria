#!/bin/bash
set -e

MISSKEY_DIR="$(cd "$(dirname "$0")/../../misskey" && pwd)"

echo "=== Misskey E2E Test Setup ==="

# 1. PostgreSQL起動
echo "[1/6] Starting PostgreSQL..."
pg_ctlcluster 16 main start 2>/dev/null || true
until pg_isready -q; do sleep 1; done

# 2. Redis起動
echo "[2/6] Starting Redis..."
redis-cli ping >/dev/null 2>&1 || redis-server --daemonize yes

# 2.5. 先にMisskeyを停止（DBをdropするため接続を切る）
echo "[2.5/6] Stopping existing Misskey..."
fuser -k 3000/tcp 2>/dev/null || true
sleep 3

# 3. DB再作成
echo "[3/6] Recreating database..."
sudo -u postgres psql -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='misskey' AND pid != pg_backend_pid();" 2>/dev/null
sudo -u postgres psql -c "DROP DATABASE IF EXISTS misskey;" 2>/dev/null
sudo -u postgres psql -c "CREATE DATABASE misskey OWNER misskey;" 2>/dev/null

# 4. マイグレーション
echo "[4/6] Running migrations..."
cd "$MISSKEY_DIR"
pnpm migrate 2>&1 | tail -3

# 5. Misskey起動
echo "[5/6] Starting Misskey..."
NODE_ENV=production pnpm start &>/tmp/misskey.log &

# 6. ヘルスチェック
echo "[6/6] Waiting for Misskey to start..."
for i in $(seq 1 60); do
  if curl -s -X POST http://127.0.0.1:3000/api/ping \
    -H 'Content-Type: application/json' -d '{}' 2>/dev/null | grep -q pong; then
    echo "Misskey is ready!"

    # 7. アカウント作成
    echo "[7/7] Creating test accounts..."
    ADMIN=$(curl -s -X POST http://127.0.0.1:3000/api/admin/accounts/create \
      -H 'Content-Type: application/json' \
      -d '{"username":"admin","password":"adminpassword"}')
    ADMIN_TOKEN=$(echo "$ADMIN" | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])")

    # federation有効化 + レートリミット緩和
    curl -s -X POST http://127.0.0.1:3000/api/admin/update-meta \
      -H 'Content-Type: application/json' \
      -d "{\"i\":\"$ADMIN_TOKEN\",\"federation\":\"all\"}" >/dev/null
    curl -s -X POST http://127.0.0.1:3000/api/admin/roles/update-default-policies \
      -H 'Content-Type: application/json' \
      -d "{\"i\":\"$ADMIN_TOKEN\",\"policies\":{\"rateLimitFactor\":0}}" >/dev/null

    # テストユーザー作成
    USER=$(curl -s -X POST http://127.0.0.1:3000/api/admin/accounts/create \
      -H 'Content-Type: application/json' \
      -d "{\"i\":\"$ADMIN_TOKEN\",\"username\":\"testuser\",\"password\":\"testpassword\"}")
    USER_TOKEN=$(echo "$USER" | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])")

    echo "ADMIN_TOKEN=$ADMIN_TOKEN"
    echo "USER_TOKEN=$USER_TOKEN"

    # トークンをファイルに保存
    echo "$ADMIN_TOKEN" > /tmp/misskey_admin_token
    echo "$USER_TOKEN" > /tmp/misskey_user_token

    echo "Setup complete!"
    exit 0
  fi
  sleep 2
done

echo "ERROR: Misskey failed to start"
tail -20 /tmp/misskey.log
exit 1
