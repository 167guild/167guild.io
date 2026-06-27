#!/usr/bin/env bash
# =============================================================================
# 167 Guild Wiki — Backup Script
# =============================================================================
#
# Purpose:
#   Create a full backup of all persistent application data:
#     - PostgreSQL database dump
#     - Wiki.js uploads and application data
#     - Application configuration
#     - Environment variable template (.env.example)
#
# Usage:
#   ./scripts/backup/backup.sh [env-file]
#
#   Or via Taskfile:
#     task backup
#
# Requirements:
#   - Docker and Docker Compose must be installed and running.
#   - PostgreSQL and Wiki.js Docker volumes must exist.
#   - A valid environment file must be present in the repository root.
#
# Output:
#   Backup artifacts are written to: ./backups/YYYY-MM-DDTHH-MM-SS/
#
# Notes:
#   - The .env file is NEVER included in backups (contains secrets).
#   - Only .env.example (the template) is archived.
#   - TODO: Add offsite upload (future issue).
#   - TODO: Add retention policy (future issue).
#   - TODO: Add checksum verification (future issue).
#   - TODO: Add encryption (future issue).
#
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

TIMESTAMP="$(date -u '+%Y-%m-%dT%H-%M-%S')"
BACKUP_DIR="${REPO_ROOT}/backups/${TIMESTAMP}"

ENV_FILE_INPUT="${1:-${ENV_FILE:-.env}}"
if [[ "${ENV_FILE_INPUT}" = /* ]]; then
  ENV_FILE="${ENV_FILE_INPUT}"
else
  ENV_FILE="${REPO_ROOT}/${ENV_FILE_INPUT}"
fi
COMPOSE_CMD=(docker compose --env-file "${ENV_FILE}" -f "${REPO_ROOT}/docker-compose.yml")

# Load environment variables for database credentials
if [[ -f "${ENV_FILE}" ]]; then
  set -o allexport
  # shellcheck source=/dev/null
  source "${ENV_FILE}"
  set +o allexport
else
  echo "ERROR: .env file not found at ${ENV_FILE}" >&2
  echo "       Copy .env.example to .env and fill in the required values." >&2
  exit 1
fi

POSTGRES_DB="${POSTGRES_DB:-wikidb}"
POSTGRES_USER="${POSTGRES_USER:-wikijs}"
PROJECT_NAME="${PROJECT_NAME:-167guild-wiki}"
POSTGRES_VOLUME="${PROJECT_NAME}_postgres_data"
WIKIJS_VOLUME="${PROJECT_NAME}_wikijs_data"

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

log() {
  echo "[backup] $*"
}

# -----------------------------------------------------------------------------
# Backup Functions
# -----------------------------------------------------------------------------

backup_postgres() {
  local output_file="${BACKUP_DIR}/postgres.sql.gz"
  log "Backing up PostgreSQL database (${POSTGRES_DB})..."
  "${COMPOSE_CMD[@]}" exec -T postgres pg_dump -U "${POSTGRES_USER}" "${POSTGRES_DB}" | gzip -c >"${output_file}"
  log "✅ PostgreSQL backup written: ${output_file}"
}

backup_wikijs_data() {
  local output_file="${BACKUP_DIR}/wikijs_data.tar.gz"
  log "Backing up Wiki.js data volume (${WIKIJS_VOLUME})..."
  docker run --rm \
    -v "${WIKIJS_VOLUME}:/data:ro" \
    -v "${BACKUP_DIR}:/backup" \
    alpine:3.20 sh -c "tar czf /backup/wikijs_data.tar.gz -C /data ."
  log "✅ Wiki.js data backup written: ${output_file}"
}

backup_config() {
  local output_file="${BACKUP_DIR}/config.tar.gz"
  log "Backing up configuration files..."
  tar czf "${output_file}" -C "${REPO_ROOT}" config deploy/production deploy/scripts
  log "✅ Configuration backup written: ${output_file}"
}

backup_env_template() {
  local output_file="${BACKUP_DIR}/.env.example"
  cp "${REPO_ROOT}/.env.example" "${output_file}"
  log "✅ Environment template copied: ${output_file}"
}

validate_runtime() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: docker is required but not installed." >&2
    exit 1
  fi

  if ! "${COMPOSE_CMD[@]}" ps >/dev/null 2>&1; then
    echo "ERROR: Unable to query docker compose services using ${ENV_FILE}." >&2
    echo "       Ensure Docker is running and the environment file is valid." >&2
    exit 1
  fi

  if ! docker volume inspect "${POSTGRES_VOLUME}" >/dev/null 2>&1; then
    echo "ERROR: Required volume not found: ${POSTGRES_VOLUME}" >&2
    echo "       Start the stack at least once to initialize volumes." >&2
    exit 1
  fi

  if ! docker volume inspect "${WIKIJS_VOLUME}" >/dev/null 2>&1; then
    echo "ERROR: Required volume not found: ${WIKIJS_VOLUME}" >&2
    echo "       Start the stack at least once to initialize volumes." >&2
    exit 1
  fi
}

write_manifest() {
  local manifest_file="${BACKUP_DIR}/manifest.txt"
  {
    echo "timestamp=${TIMESTAMP}"
    echo "environment_file=$(basename "${ENV_FILE}")"
    echo "project_name=${PROJECT_NAME}"
    echo "postgres_db=${POSTGRES_DB}"
    echo "postgres_user=${POSTGRES_USER}"
    echo "artifacts=postgres.sql.gz,wikijs_data.tar.gz,config.tar.gz,.env.example"
    echo ""
    echo "sha256:"
    (
      cd "${BACKUP_DIR}"
      sha256sum postgres.sql.gz wikijs_data.tar.gz config.tar.gz .env.example
    )
  } >"${manifest_file}"
  log "✅ Backup manifest written: ${manifest_file}"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
  log "Starting backup — ${TIMESTAMP}"
  log "Backup directory: ${BACKUP_DIR}"
  log "Environment file: ${ENV_FILE}"

  mkdir -p "${BACKUP_DIR}"
  validate_runtime

  backup_postgres
  backup_wikijs_data
  backup_config
  backup_env_template
  write_manifest

  log "Backup complete."
}

main "$@"
