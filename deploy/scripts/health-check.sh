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
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a

echo "🔎 Checking container status..."
"${COMPOSE_CMD[@]}" ps

echo "🔎 Validating Docker health states..."
unhealthy_services="$("${COMPOSE_CMD[@]}" ps --format '{{.Service}}\t{{.Status}}' | awk -F '\t' '$2 ~ /unhealthy|Exited/ {print $1 ": " $2}')"
if [[ -n "${unhealthy_services}" ]]; then
  echo "❌ Unhealthy or exited services detected:"
  echo "${unhealthy_services}"
  exit 1
fi

echo "🔎 Checking Wiki.js health endpoint..."
# Fail only when both the compose-configured endpoint and root endpoint are unreachable.
if ! "${COMPOSE_CMD[@]}" exec -T wikijs wget -q --spider http://localhost:3000/healthz \
  && ! "${COMPOSE_CMD[@]}" exec -T wikijs wget -q --spider http://localhost:3000/; then
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
if ! "${COMPOSE_CMD[@]}" exec -T caddy wget -q --spider --timeout=10 "http://localhost"; then
  echo "❌ Caddy in-container endpoint check failed at http://localhost."
  echo "Verify Caddy runtime and inspect logs with: docker compose --env-file $ENV_FILE -f docker-compose.yml -f deploy/production/docker-compose.production.yml logs caddy"
  exit 1
fi

if ! wget -q --spider --timeout=10 "http://localhost"; then
  echo "❌ Caddy local endpoint check failed at http://localhost."
  echo "Verify the caddy container is running and inspect logs."
  exit 1
fi

if getent hosts "${DOMAIN}" >/dev/null 2>&1; then
  if ! wget -q --spider --timeout=10 "https://${DOMAIN}"; then
    echo "❌ Caddy HTTPS check failed for https://${DOMAIN}."
    echo "This can indicate DNS routing, TLS provisioning, or Caddy runtime issues."
    echo "Check DNS, TLS state, and Caddy logs: docker compose --env-file $ENV_FILE -f docker-compose.yml -f deploy/production/docker-compose.production.yml logs caddy"
    exit 1
  fi
else
  echo "ℹ️  Skipping public HTTPS check for ${DOMAIN} because DNS does not currently resolve on this host."
fi

echo "✅ Health checks passed for Caddy, Wiki.js, and PostgreSQL."
echo "ℹ️  Manual follow-up: verify Google OAuth sign-in and latest backup artifacts."
