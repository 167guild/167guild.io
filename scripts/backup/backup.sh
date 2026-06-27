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
#   ./scripts/backup/backup.sh
#
#   Or via Taskfile:
#     task backup
#
# Requirements:
#   - Docker and Docker Compose must be installed and running.
#   - The stack must be running (docker compose up -d) before running a backup.
#   - A valid .env file must be present in the repository root.
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

COMPOSE_FILE="${REPO_ROOT}/docker-compose.yml"
ENV_FILE="${REPO_ROOT}/.env"

# Load environment variables for database credentials
if [[ -f "${ENV_FILE}" ]]; then
  # shellcheck source=/dev/null
  set -o allexport
  source "${ENV_FILE}"
  set +o allexport
else
  echo "ERROR: .env file not found at ${ENV_FILE}" >&2
  echo "       Copy .env.example to .env and fill in the required values." >&2
  exit 1
fi

POSTGRES_DB="${POSTGRES_DB:-wikidb}"
POSTGRES_USER="${POSTGRES_USER:-wikijs}"

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
  # TODO: Implement PostgreSQL backup using pg_dump.
  #
  # Planned implementation:
  #   docker compose exec -T postgres \
  #     pg_dump -U "${POSTGRES_USER}" "${POSTGRES_DB}" \
  #     | gzip > "${BACKUP_DIR}/postgres.sql.gz"
  #
  log "TODO: PostgreSQL backup not yet implemented."
  log "      Target: ${BACKUP_DIR}/postgres.sql.gz"
}

backup_wikijs_data() {
  # TODO: Implement Wiki.js data volume backup using a temporary container.
  #
  # Planned implementation:
  #   docker run --rm \
  #     -v 167guild-wiki_wikijs_data:/data:ro \
  #     -v "${BACKUP_DIR}":/backup \
  #     alpine tar czf /backup/wikijs_data.tar.gz -C /data .
  #
  log "TODO: Wiki.js data backup not yet implemented."
  log "      Target: ${BACKUP_DIR}/wikijs_data.tar.gz"
}

backup_config() {
  # TODO: Implement configuration backup by archiving the config/ directory.
  #
  # Planned implementation:
  #   tar czf "${BACKUP_DIR}/config.tar.gz" -C "${REPO_ROOT}" config/
  #
  log "TODO: Configuration backup not yet implemented."
  log "      Target: ${BACKUP_DIR}/config.tar.gz"
}

backup_env_template() {
  # TODO: Copy .env.example (template only, never .env) into the backup.
  #
  # Planned implementation:
  #   cp "${REPO_ROOT}/.env.example" "${BACKUP_DIR}/.env.example"
  #
  log "TODO: Environment template backup not yet implemented."
  log "      Target: ${BACKUP_DIR}/.env.example"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
  log "Starting backup — ${TIMESTAMP}"
  log "Backup directory: ${BACKUP_DIR}"

  mkdir -p "${BACKUP_DIR}"

  backup_postgres
  backup_wikijs_data
  backup_config
  backup_env_template

  log "Backup complete."
  log ""
  log "TODO: Add offsite upload (future issue)."
  log "TODO: Add checksum verification (future issue)."
  log "TODO: Add retention policy cleanup (future issue)."
}

main "$@"
