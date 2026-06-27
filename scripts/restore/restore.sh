#!/usr/bin/env bash
# =============================================================================
# 167 Guild Wiki — Restore Script
# =============================================================================
#
# Purpose:
#   Restore all persistent application data from a backup archive:
#     - PostgreSQL database
#     - Wiki.js uploads and application data
#     - Application configuration
#
# Usage:
#   ./scripts/restore/restore.sh <backup-directory> [env-file]
#
#   Or via Taskfile:
#     task restore
#
# Arguments:
#   <backup-directory>   Path to the backup directory created by backup.sh.
#                        Example: ./backups/2025-01-01T00-00-00
#
# Requirements:
#   - Docker and Docker Compose must be installed.
#   - A valid environment file must be present in the repository root.
#
# WARNING:
#   Restore is a destructive operation. Existing data will be overwritten.
#   Confirm the target backup directory before proceeding.
#
# Notes:
#   - TODO: Add checksum verification before restore (future issue).
#   - TODO: Add dry-run mode (future issue).
#   - TODO: Add interactive confirmation prompt (future issue).
#
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

BACKUP_DIR_INPUT="${1:-}"
BACKUP_DIR=""
if [[ -n "${BACKUP_DIR_INPUT}" ]]; then
  if [[ "${BACKUP_DIR_INPUT}" = /* ]]; then
    BACKUP_DIR="${BACKUP_DIR_INPUT}"
  else
    BACKUP_DIR="${REPO_ROOT}/${BACKUP_DIR_INPUT}"
  fi
fi

ENV_FILE_INPUT="${2:-${ENV_FILE:-.env}}"
if [[ "${ENV_FILE_INPUT}" = /* ]]; then
  ENV_FILE="${ENV_FILE_INPUT}"
else
  ENV_FILE="${REPO_ROOT}/${ENV_FILE_INPUT}"
fi
COMPOSE_CMD=(docker compose --env-file "${ENV_FILE}" -f "${REPO_ROOT}/docker-compose.yml")

# -----------------------------------------------------------------------------
# Validation
# -----------------------------------------------------------------------------

if [[ -z "${BACKUP_DIR}" ]]; then
  echo "ERROR: No backup directory specified." >&2
  echo "       Usage: $0 <backup-directory>" >&2
  echo "       Example: $0 ./backups/2025-01-01T00-00-00" >&2
  exit 1
fi

if [[ ! -d "${BACKUP_DIR}" ]]; then
  echo "ERROR: Backup directory not found: ${BACKUP_DIR}" >&2
  exit 1
fi

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
WIKIJS_VOLUME="${PROJECT_NAME}_wikijs_data"
POSTGRES_VOLUME="${PROJECT_NAME}_postgres_data"

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

log() {
  echo "[restore] $*"
}

# -----------------------------------------------------------------------------
# Restore Functions
# -----------------------------------------------------------------------------

restore_postgres() {
  local source_file="${BACKUP_DIR}/postgres.sql.gz"
  log "Starting PostgreSQL service for restore..."
  "${COMPOSE_CMD[@]}" up -d postgres
  wait_for_postgres

  log "Resetting PostgreSQL public schema in ${POSTGRES_DB}..."
  "${COMPOSE_CMD[@]}" exec -T postgres psql -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -c "DROP SCHEMA IF EXISTS public CASCADE;"
  "${COMPOSE_CMD[@]}" exec -T postgres psql -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -c "CREATE SCHEMA public;"

  log "Restoring PostgreSQL database from ${source_file}..."
  gunzip -c "${source_file}" | "${COMPOSE_CMD[@]}" exec -T postgres psql -U "${POSTGRES_USER}" -d "${POSTGRES_DB}"
  log "✅ PostgreSQL restore complete."
}

restore_wikijs_data() {
  local source_file="${BACKUP_DIR}/wikijs_data.tar.gz"
  log "Restoring Wiki.js data volume (${WIKIJS_VOLUME})..."
  docker run --rm \
    -v "${WIKIJS_VOLUME}:/data" \
    -v "${BACKUP_DIR}:/backup:ro" \
    alpine:3.20 sh -eu -c '
      test -d /data
      test -f /backup/wikijs_data.tar.gz
      echo "Cleaning target volume..."
      find /data -mindepth 1 -delete
      echo "Extracting Wiki.js data archive..."
      tar xzf /backup/wikijs_data.tar.gz -C /data
    '
  log "✅ Wiki.js data restore complete from ${source_file}."
}

restore_config() {
  local source_file="${BACKUP_DIR}/config.tar.gz"
  log "Restoring configuration archive..."
  tar xzf "${source_file}" -C "${REPO_ROOT}"
  log "✅ Configuration restore complete from ${source_file}."
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
    echo "       Start the stack once to initialize Docker volumes before restore." >&2
    exit 1
  fi

  if ! docker volume inspect "${WIKIJS_VOLUME}" >/dev/null 2>&1; then
    echo "ERROR: Required volume not found: ${WIKIJS_VOLUME}" >&2
    echo "       Start the stack once to initialize Docker volumes before restore." >&2
    exit 1
  fi
}

validate_backup_artifacts() {
  local required_artifacts=(postgres.sql.gz wikijs_data.tar.gz config.tar.gz .env.example manifest.txt)
  local missing_artifacts=()
  for artifact in "${required_artifacts[@]}"; do
    if [[ ! -f "${BACKUP_DIR}/${artifact}" ]]; then
      missing_artifacts+=("${artifact}")
    fi
  done

  if [[ ${#missing_artifacts[@]} -gt 0 ]]; then
    echo "ERROR: Backup directory is missing required artifacts:" >&2
    printf ' - %s\n' "${missing_artifacts[@]}" >&2
    exit 1
  fi

  log "Verifying backup checksums from manifest..."
  if ! grep -q '^sha256:$' "${BACKUP_DIR}/manifest.txt"; then
    echo "ERROR: Backup manifest is missing required 'sha256:' section." >&2
    exit 1
  fi
  if [[ -z "$(awk '/^sha256:/{flag=1; next} flag {print}' "${BACKUP_DIR}/manifest.txt")" ]]; then
    echo "ERROR: Backup manifest does not contain checksum entries." >&2
    exit 1
  fi
  (
    cd "${BACKUP_DIR}"
    awk '/^sha256:/{flag=1; next} flag {print}' manifest.txt | sha256sum --check --status
  )
  log "✅ Backup manifest checksum verification passed."
}

wait_for_postgres() {
  local attempt=1
  local max_attempts=30
  while (( attempt <= max_attempts )); do
    if "${COMPOSE_CMD[@]}" exec -T postgres pg_isready -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
    attempt=$((attempt + 1))
  done

  echo "ERROR: PostgreSQL did not become ready in time for restore." >&2
  exit 1
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
  log "Starting restore from: ${BACKUP_DIR}"
  log "Environment file: ${ENV_FILE}"
  log ""
  log "WARNING: This is a destructive operation."
  log "         Existing data will be overwritten."
  log ""

  validate_runtime
  validate_backup_artifacts
  log "Stopping active stack to ensure restore consistency..."
  "${COMPOSE_CMD[@]}" down --remove-orphans

  restore_config
  restore_wikijs_data
  restore_postgres
  "${COMPOSE_CMD[@]}" stop postgres >/dev/null 2>&1 || true

  log "Restore complete."
  log ""
  log "Next steps:"
  log "  1. Start the stack: task up"
  log "  2. Verify service health: task health"
  log "  3. Validate restored data and authentication flow."
}

main "$@"
