#!/usr/bin/env bash

set -euo pipefail

ENV_FILE="${1:-.env.production}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ Missing environment file: $ENV_FILE"
  echo "Create it from deploy/examples/.env.production.example and see deploy/README.md."
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

required_vars=(
  APP_ENV
  DOMAIN
  EMAIL
  WIKI_BASE_URL
  POSTGRES_DB
  POSTGRES_USER
  POSTGRES_PASSWORD
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
  echo "❌ Missing required production environment variables in $ENV_FILE:"
  printf ' - %s\n' "${missing[@]}"
  echo "See deploy/README.md for required values."
  exit 1
fi

if [[ "${APP_ENV}" != "production" ]]; then
  echo "❌ APP_ENV must be set to production in $ENV_FILE."
  exit 1
fi

declare -A placeholder_by_var=(
  [EMAIL]="admin@example.com"
  [POSTGRES_PASSWORD]="REPLACE_WITH_STRONG_PASSWORD"
  [GOOGLE_OAUTH_CLIENT_ID]="replace-with-google-client-id"
  [GOOGLE_OAUTH_CLIENT_SECRET]="replace-with-google-client-secret"
)

for var_name in "${!placeholder_by_var[@]}"; do
  if [[ "${!var_name}" == "${placeholder_by_var[$var_name]}" ]]; then
    echo "❌ Placeholder value detected for $var_name in $ENV_FILE."
    echo "Replace all placeholder values before deploying. See deploy/README.md."
    exit 1
  fi
done

if [[ "${DOMAIN}" == *"://"* || "${DOMAIN}" == */* ]]; then
  echo "❌ DOMAIN must be a hostname only (no scheme/path): ${DOMAIN}"
  exit 1
fi

invalid_domain_suffixes=("example.com" "example.org" "example.net" "test.com" "localhost")
for invalid_suffix in "${invalid_domain_suffixes[@]}"; do
  if [[ "${DOMAIN}" == "${invalid_suffix}" || "${DOMAIN}" == *".${invalid_suffix}" ]]; then
    echo "❌ DOMAIN must be a real production hostname, not a local/example placeholder."
    exit 1
  fi
done

if [[ "${DOMAIN}" =~ \.local$ ]]; then
  echo "❌ DOMAIN cannot end with .local in production."
  exit 1
fi

ipv4_regex='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
if [[ "${DOMAIN}" =~ ${ipv4_regex} ]]; then
  echo "❌ DOMAIN must be a DNS hostname, not an IP address."
  exit 1
fi

if [[ ! "${WIKI_BASE_URL}" =~ ^https:// ]]; then
  echo "❌ WIKI_BASE_URL must use HTTPS in production."
  exit 1
fi

if [[ ! "${GOOGLE_OAUTH_CALLBACK_URL}" =~ ^https:// ]]; then
  echo "❌ GOOGLE_OAUTH_CALLBACK_URL must use HTTPS in production."
  exit 1
fi

callback_path="/login/callback"
# Google OAuth callback URLs must match exactly; remove trailing slash for consistent comparison.
expected_callback="${WIKI_BASE_URL%/}${callback_path}"
if [[ "${GOOGLE_OAUTH_CALLBACK_URL}" != "${expected_callback}" ]]; then
  echo "❌ GOOGLE_OAUTH_CALLBACK_URL must match ${expected_callback}"
  exit 1
fi

echo "✅ Production environment validation passed for $ENV_FILE."
