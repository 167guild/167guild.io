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

placeholder_values=(
  "example.com"
  "admin@example.com"
  "REPLACE_WITH_STRONG_PASSWORD"
  "replace-with-google-client-id"
  "replace-with-google-client-secret"
)

for value in "${placeholder_values[@]}"; do
  if grep -q "$value" "$ENV_FILE"; then
    echo "❌ Placeholder value detected in $ENV_FILE: $value"
    echo "Replace all placeholder values before deploying. See deploy/README.md."
    exit 1
  fi
done

echo "✅ Production environment validation passed for $ENV_FILE."
