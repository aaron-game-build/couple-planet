#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env.cloud.dev"
COMPOSE_FILE="${ROOT_DIR}/docker-compose.cloud.dev.yml"
BACKUP_DIR="${ROOT_DIR}/backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Missing ${ENV_FILE}"
  exit 1
fi

mkdir -p "${BACKUP_DIR}"

# shellcheck disable=SC1090
source "${ENV_FILE}"

POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-couple_planet}"
OUTPUT_FILE="${BACKUP_DIR}/couple_planet_${TIMESTAMP}.sql"

echo "Creating backup to ${OUTPUT_FILE} ..."
docker compose --env-file "${ENV_FILE}" -f "${COMPOSE_FILE}" exec -T postgres \
  pg_dump -U "${POSTGRES_USER}" "${POSTGRES_DB}" > "${OUTPUT_FILE}"

echo "Backup completed: ${OUTPUT_FILE}"
