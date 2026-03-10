#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/Users/aaronking/Documents/aiProject/couple-planet/@couple-planet"
API_DIR="$ROOT_DIR/apps/api"
MOBILE_DIR="$ROOT_DIR/apps/mobile"
HEALTH_URL="${HEALTH_URL:-http://localhost:3000/api/v1/health}"
API_PORT="${API_PORT:-3000}"
DATABASE_URL="${DATABASE_URL:-postgresql://aaronking@localhost:5432/couple_planet}"
JWT_SECRET="${JWT_SECRET:-replace_me}"
API_BASE_URL="${API_BASE_URL:-http://localhost:3000/api/v1}"
DEVICE_ID="${DEVICE_ID:-16E9CA50-0963-4BC9-A15F-D125C8B49D74}"
MODE="all"

usage() {
  cat <<'EOF'
Usage:
  bash run.sh [--api-only | --mobile-only]

Modes:
  (default)      Start API then mobile
  --api-only     Start API only
  --mobile-only  Start mobile only (won't start API)
EOF
}

for arg in "$@"; do
  case "$arg" in
    --api-only)
      MODE="api-only"
      ;;
    --mobile-only)
      MODE="mobile-only"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      usage
      exit 1
      ;;
  esac
done

if ! command -v corepack >/dev/null 2>&1; then
  echo "corepack not found. Please install Node.js with corepack."
  exit 1
fi

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter not found in PATH. Please install Flutter first."
  exit 1
fi

cd "$ROOT_DIR"

echo "== Prepare dependencies =="
corepack enable >/dev/null 2>&1 || true
corepack prepare pnpm@10.6.0 --activate >/dev/null 2>&1 || true
corepack pnpm install

cd "$MOBILE_DIR"
flutter pub get

if [[ "$MODE" != "mobile-only" ]]; then
  echo "== Start API on :$API_PORT =="
  cd "$API_DIR"
  DATABASE_URL="$DATABASE_URL" API_PORT="$API_PORT" JWT_SECRET="$JWT_SECRET" corepack pnpm dev >/tmp/couple_planet_api.log 2>&1 &
  API_PID=$!

  cleanup() {
    if kill -0 "$API_PID" >/dev/null 2>&1; then
      kill "$API_PID" >/dev/null 2>&1 || true
    fi
  }
  trap cleanup EXIT INT TERM

  echo "== Wait API health =="
  for _ in {1..40}; do
    if curl -sSf "$HEALTH_URL" >/dev/null 2>&1; then
      echo "API is healthy."
      break
    fi
    sleep 1
  done

  if ! curl -sSf "$HEALTH_URL" >/dev/null 2>&1; then
    echo "API failed to start. Check /tmp/couple_planet_api.log"
    exit 1
  fi
fi

if [[ "$MODE" == "api-only" ]]; then
  echo "API only mode finished startup."
  echo "Logs: /tmp/couple_planet_api.log"
  wait "$API_PID"
  exit 0
fi

echo "== Start mobile =="
cd "$MOBILE_DIR"
flutter run -d "$DEVICE_ID" --dart-define=API_BASE_URL="$API_BASE_URL"