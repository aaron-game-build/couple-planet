#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TARGET_BASE="${ROOT_DIR}/docs/release/evidence"
STAMP="$(date '+%Y%m%d-%H%M%S')"
TARGET_DIR="${TARGET_BASE}/${STAMP}"

mkdir -p "${TARGET_DIR}"

copy_if_exists() {
  local src="$1"
  if [[ -f "${ROOT_DIR}/${src}" ]]; then
    cp "${ROOT_DIR}/${src}" "${TARGET_DIR}/"
    echo "copied: ${src}"
  else
    echo "missing: ${src}"
  fi
}

copy_if_exists "docs/release/testflight-preupload-checklist-v1.md"
copy_if_exists "docs/release/go-no-go-latest.md"
copy_if_exists "docs/release/release-checklist.md"
copy_if_exists "docs/release/testflight-dry-run-latest.md"
copy_if_exists "docs/release/testflight-upload-execution-2026-03-10.md"
copy_if_exists "docs/operations/cloud-dev-execution-round-002.md"
copy_if_exists "docs/couple-planet/week1-flow-regression-evidence-2026-03-10.md"

if command -v curl >/dev/null 2>&1; then
  {
    echo "# Health Snapshot"
    echo ""
    echo "- Generated At: $(date '+%Y-%m-%d %H:%M:%S %Z')"
    echo "- Endpoint: http://localhost:3000/api/v1/health"
    echo ""
    printf '%s\n' '```json'
    curl -sS http://localhost:3000/api/v1/health || true
    echo ""
    printf '%s\n' '```'
  } > "${TARGET_DIR}/health-snapshot.md"
fi

echo "evidence archived at: ${TARGET_DIR}"
