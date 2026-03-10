#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env.cloud.dev"
ENV_EXAMPLE="${ROOT_DIR}/.env.cloud.dev.example"
COMPOSE_FILE="${ROOT_DIR}/docker-compose.cloud.dev.yml"
HEALTH_URL="${HEALTH_URL:-http://localhost:3000/api/v1/health}"

if [[ ! -f "${COMPOSE_FILE}" ]]; then
  echo "Missing ${COMPOSE_FILE}"
  exit 1
fi

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Creating .env.cloud.dev from example..."
  cp "${ENV_EXAMPLE}" "${ENV_FILE}"
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required"
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "docker compose plugin is required"
  exit 1
fi

echo "Starting cloud-dev stack..."
docker compose --env-file "${ENV_FILE}" -f "${COMPOSE_FILE}" up -d --build

echo "Waiting for API health..."
for _ in {1..40}; do
  if curl -sSf "${HEALTH_URL}" >/dev/null 2>&1; then
    echo "API is healthy: ${HEALTH_URL}"
    exit 0
  fi
  sleep 2
done

echo "API health check failed. Inspect logs:"
echo "docker compose --env-file ${ENV_FILE} -f ${COMPOSE_FILE} logs -f api"
exit 1
