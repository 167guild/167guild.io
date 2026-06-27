#!/usr/bin/env bash

set -euo pipefail

ENV_FILE="${1:-.env.production}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ Missing environment file: $ENV_FILE"
  echo "Create it from deploy/examples/.env.production.example and see deploy/README.md."
  exit 1
fi

set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a

error() {
  echo "❌ $*" >&2
  exit 1
}

required_vars=(
  APP_ENV
  DOMAIN
  EMAIL
  WIKI_BASE_URL
  WIKI_UPSTREAM
  POSTGRES_DB
  POSTGRES_USER
  POSTGRES_PASSWORD
  DB_HOST
  DB_PORT
  GOOGLE_OAUTH_CLIENT_ID
  GOOGLE_OAUTH_CLIENT_SECRET
  GOOGLE_OAUTH_CALLBACK_URL
)

missing=()
for var_name in "${required_vars[@]}"; do
  if [[ -z "${!var_name:-}" ]]; then
    missing+=("$var_name")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "❌ Missing required production environment variables in $ENV_FILE:" >&2
  printf ' - %s\n' "${missing[@]}"
  echo "See deploy/README.md for required values." >&2
  exit 1
fi

if [[ "${APP_ENV}" != "production" ]]; then
  error "APP_ENV must be set to production in $ENV_FILE."
fi

declare -A placeholder_by_var=(
  [EMAIL]="admin@example.com"
  [POSTGRES_PASSWORD]="REPLACE_WITH_STRONG_PASSWORD"
  [GOOGLE_OAUTH_CLIENT_ID]="replace-with-google-client-id"
  [GOOGLE_OAUTH_CLIENT_SECRET]="replace-with-google-client-secret"
)

for var_name in "${!placeholder_by_var[@]}"; do
  if [[ "${!var_name}" == "${placeholder_by_var[$var_name]}" ]]; then
    error "Placeholder value detected for $var_name in $ENV_FILE. Replace all placeholders before deploying."
  fi
done

if [[ "${DOMAIN}" == *"://"* || "${DOMAIN}" == */* ]]; then
  error "DOMAIN must be a hostname only (no scheme/path): ${DOMAIN}"
fi

invalid_domain_suffixes=("example.com" "example.org" "example.net" "test.com" "test.local" "example.localhost" "localhost" "test" "invalid" "example")
for invalid_suffix in "${invalid_domain_suffixes[@]}"; do
  if [[ "${DOMAIN}" == "${invalid_suffix}" || "${DOMAIN}" == *".${invalid_suffix}" ]]; then
    error "DOMAIN must be a real production hostname, not a local/example placeholder."
  fi
done

if [[ "${DOMAIN}" =~ \.local$ ]]; then
  error "DOMAIN cannot end with .local in production."
fi

# Reject literal IPv4 addresses by matching strictly valid 0-255 octets.
ipv4_regex='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
if [[ "${DOMAIN}" =~ ${ipv4_regex} ]]; then
  error "DOMAIN must be a DNS hostname, not an IP address."
fi

domain_regex='^([A-Za-z0-9-]+\.)+[A-Za-z]{2,}$'
if [[ ! "${DOMAIN}" =~ ${domain_regex} ]]; then
  error "DOMAIN must look like a valid DNS hostname (example: wiki.example.com)."
fi

if [[ ! "${EMAIL}" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
  error "EMAIL must be a valid email address for ACME notifications."
fi

if [[ "${DB_HOST}" != "postgres" ]]; then
  error "DB_HOST must be set to postgres to match the Docker Compose service name."
fi

if [[ "${DB_PORT}" != "5432" ]]; then
  error "DB_PORT must be set to 5432 to match the PostgreSQL service configuration."
fi

if [[ "${WIKI_UPSTREAM}" != "wikijs:3000" ]]; then
  error "WIKI_UPSTREAM must be set to wikijs:3000 for the internal reverse proxy route."
fi

wiki_base_regex='^https://([^/]+)$'
if [[ ! "${WIKI_BASE_URL}" =~ ${wiki_base_regex} ]]; then
  error "WIKI_BASE_URL must be an HTTPS origin with no path/query/fragment (example: https://167guild.io)."
fi
wiki_base_host="${BASH_REMATCH[1]}"
if [[ "${wiki_base_host}" != "${DOMAIN}" ]]; then
  error "WIKI_BASE_URL host (${wiki_base_host}) must match DOMAIN (${DOMAIN})."
fi

callback_regex='^https://([^/]+)/login/callback$'
if [[ ! "${GOOGLE_OAUTH_CALLBACK_URL}" =~ ${callback_regex} ]]; then
  error "GOOGLE_OAUTH_CALLBACK_URL must be HTTPS and end with /login/callback."
fi
callback_host="${BASH_REMATCH[1]}"
if [[ "${callback_host}" != "${DOMAIN}" ]]; then
  error "GOOGLE_OAUTH_CALLBACK_URL host (${callback_host}) must match DOMAIN (${DOMAIN})."
fi

if [[ "${GOOGLE_OAUTH_CALLBACK_URL}" != "${WIKI_BASE_URL}/login/callback" ]]; then
  error "GOOGLE_OAUTH_CALLBACK_URL must exactly equal ${WIKI_BASE_URL}/login/callback."
fi

echo "✅ Production environment validation passed for $ENV_FILE."
