#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MOBILE_DIR="${ROOT_DIR}/apps/mobile"
REPORT_DIR="${ROOT_DIR}/docs/release"
REPORT_FILE="${REPORT_DIR}/testflight-dry-run-latest.md"
RUN_AT="$(date '+%Y-%m-%d %H:%M:%S %Z')"

mkdir -p "${REPORT_DIR}"

exec_step() {
  local name="$1"
  shift
  echo "== ${name} =="
  "$@"
}

{
  echo "# TestFlight Dry Run Report"
  echo ""
  echo "- Run At: ${RUN_AT}"
  echo "- Host: $(hostname)"
  echo ""
} > "${REPORT_FILE}"

cd "${MOBILE_DIR}"

{
  echo "## 1) flutter pub get"
  if exec_step "flutter pub get" flutter pub get; then
    echo "- Result: PASS"
  else
    echo "- Result: FAIL"
    exit 1
  fi
  echo ""
} >> "${REPORT_FILE}"

{
  echo "## 2) flutter analyze"
  if exec_step "flutter analyze" flutter analyze; then
    echo "- Result: PASS"
  else
    echo "- Result: FAIL"
    exit 1
  fi
  echo ""
} >> "${REPORT_FILE}"

{
  echo "## 3) flutter test"
  if exec_step "flutter test" flutter test; then
    echo "- Result: PASS"
  else
    echo "- Result: FAIL"
    exit 1
  fi
  echo ""
} >> "${REPORT_FILE}"

{
  echo "## 4) flutter build ios --release --no-codesign"
  if exec_step "flutter build ios --release --no-codesign" flutter build ios --release --no-codesign; then
    echo "- Result: PASS"
  else
    echo "- Result: FAIL"
    exit 1
  fi
  echo ""
} >> "${REPORT_FILE}"

{
  echo "## 5) Next Step"
  echo "- Open Xcode Organizer and upload the generated archive with proper signing."
} >> "${REPORT_FILE}"

echo "Dry run completed. Report: ${REPORT_FILE}"
