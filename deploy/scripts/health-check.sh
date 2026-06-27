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
if "${COMPOSE_CMD[@]}" exec -T wikijs wget -q --spider http://localhost:3000/healthz; then
  :
elif "${COMPOSE_CMD[@]}" exec -T wikijs wget -q --spider http://localhost:3000/; then
  :
else
  echo "❌ Wiki.js health check failed (/healthz and /)."
  echo "Verify the wikijs container is running and inspect logs with: docker compose --env-file $ENV_FILE -f docker-compose.yml -f deploy/production/docker-compose.production.yml logs wikijs"
  exit 1
fi

echo "🔎 Checking PostgreSQL readiness..."
if ! "${COMPOSE_CMD[@]}" exec -T postgres pg_isready -U "${POSTGRES_USER}" -d "${POSTGRES_DB}"; then
  echo "❌ PostgreSQL readiness check failed."
  echo "Verify the postgres container is running and credentials in $ENV_FILE are correct."
  exit 1
fi

echo "🔎 Checking Caddy endpoint..."
if ! wget -q --spider --timeout=10 "https://${DOMAIN}"; then
  echo "❌ Caddy HTTPS check failed for https://${DOMAIN}."
  echo "This can indicate DNS routing, TLS provisioning, or Caddy runtime issues."
  echo "Check DNS, TLS state, and Caddy logs: docker compose --env-file $ENV_FILE -f docker-compose.yml -f deploy/production/docker-compose.production.yml logs caddy"
  exit 1
fi

echo "✅ Health checks passed for Caddy, Wiki.js, and PostgreSQL."
echo "ℹ️  Manual follow-up: verify Google OAuth sign-in and latest backup artifacts."
