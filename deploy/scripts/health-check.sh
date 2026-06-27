#!/usr/bin/env bash

set -euo pipefail

ENV_FILE="${1:-.env.production}"
COMPOSE_CMD=(docker compose --env-file "$ENV_FILE" -f docker-compose.yml -f deploy/production/docker-compose.production.yml)

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ Missing environment file: $ENV_FILE"
  echo "Create it from deploy/examples/.env.production.example and see deploy/README.md."
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

echo "🔎 Checking container status..."
"${COMPOSE_CMD[@]}" ps

echo "🔎 Checking Wiki.js health endpoint..."
"${COMPOSE_CMD[@]}" exec -T wikijs wget -q --spider http://localhost:3000/healthz

echo "🔎 Checking PostgreSQL readiness..."
"${COMPOSE_CMD[@]}" exec -T postgres pg_isready -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" >/dev/null

echo "🔎 Checking Caddy endpoint..."
curl -fsS --max-time 10 "https://${DOMAIN}" >/dev/null

echo "✅ Health checks passed for Caddy, Wiki.js, and PostgreSQL."
echo "ℹ️  Manual follow-up: verify Google OAuth sign-in and latest backup artifacts."
