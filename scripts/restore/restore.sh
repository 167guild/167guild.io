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
#   ./scripts/restore/restore.sh <backup-directory>
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
#   - The stack should be stopped before restoring data.
#   - A valid .env file must be present in the repository root.
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

BACKUP_DIR="${1:-}"

COMPOSE_FILE="${REPO_ROOT}/docker-compose.yml"
ENV_FILE="${REPO_ROOT}/.env"

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
  echo "[restore] $*"
}

# -----------------------------------------------------------------------------
# Restore Functions
# -----------------------------------------------------------------------------

restore_postgres() {
  # TODO: Implement PostgreSQL restore from a pg_dump archive.
  #
  # Planned implementation:
  #   gunzip -c "${BACKUP_DIR}/postgres.sql.gz" \
  #     | docker compose exec -T postgres \
  #         psql -U "${POSTGRES_USER}" "${POSTGRES_DB}"
  #
  # Note: The database must exist and be empty before restoring.
  #       Drop and recreate if necessary.
  #
  log "TODO: PostgreSQL restore not yet implemented."
  log "      Source: ${BACKUP_DIR}/postgres.sql.gz"
}

restore_wikijs_data() {
  # TODO: Implement Wiki.js data volume restore from a tarball.
  #
  # Planned implementation:
  #   docker run --rm \
  #     -v 167guild-wiki_wikijs_data:/data \
  #     -v "${BACKUP_DIR}":/backup:ro \
  #     alpine sh -c "rm -rf /data/* && tar xzf /backup/wikijs_data.tar.gz -C /data"
  #
  log "TODO: Wiki.js data restore not yet implemented."
  log "      Source: ${BACKUP_DIR}/wikijs_data.tar.gz"
}

restore_config() {
  # TODO: Implement configuration restore by extracting the config/ tarball.
  #
  # Planned implementation:
  #   tar xzf "${BACKUP_DIR}/config.tar.gz" -C "${REPO_ROOT}"
  #
  log "TODO: Configuration restore not yet implemented."
  log "      Source: ${BACKUP_DIR}/config.tar.gz"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
  log "Starting restore from: ${BACKUP_DIR}"
  log ""
  log "WARNING: This is a destructive operation."
  log "         Existing data will be overwritten."
  log ""

  # TODO: Add interactive confirmation prompt (future issue).

  restore_postgres
  restore_wikijs_data
  restore_config

  log "Restore complete."
  log ""
  log "Next steps:"
  log "  1. Verify the restored data."
  log "  2. Start the stack: task up"
  log "  3. Confirm the wiki is accessible."
}

main "$@"
