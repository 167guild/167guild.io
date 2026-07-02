#!/usr/bin/env bash
# =============================================================================
# bootstrap.sh — Run all first-boot bootstrap steps for the 167 Guild Wiki.
# =============================================================================
#
# This script is the single entry point for post-installation bootstrapping.
# It must be run AFTER the Wiki.js setup wizard completes and the application
# is fully operational.
#
# Steps performed:
#   1. Wait for Wiki.js to be ready.
#   2. Seed custom groups (Dungeon Master, Player, Viewer) via PostgreSQL.
#   3. Seed starter wiki pages via the Wiki.js GraphQL API.
#
# Usage:
#   bash scripts/bootstrap/bootstrap.sh [ENV_FILE]
#
# Arguments:
#   ENV_FILE  Path to the environment file (default: .env.production)
#
# Required environment variables (set in ENV_FILE or the current environment):
#   POSTGRES_USER         PostgreSQL username
#   POSTGRES_DB           PostgreSQL database name
#   WIKI_ADMIN_EMAIL      Admin email chosen during the Wiki.js setup wizard
#   WIKI_ADMIN_PASSWORD   Admin password chosen during the Wiki.js setup wizard
#
# Optional environment variables:
#   WIKI_BASE_URL   Wiki.js URL to authenticate against (default: http://localhost:3000)
#
# Example:
#   bash scripts/bootstrap/bootstrap.sh .env.production
# =============================================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"

ENV_FILE="${1:-.env.production}"

# --------------------------------------------------------------------------- #
# Load environment variables from the env file.
# --------------------------------------------------------------------------- #
load_env() {
  if [[ ! -f "${ENV_FILE}" ]]; then
    die "Environment file not found: ${ENV_FILE}"
  fi
  log_info "Loading environment from ${ENV_FILE}..."
  set -a
  # shellcheck source=/dev/null
  source "${ENV_FILE}"
  set +a
}

# --------------------------------------------------------------------------- #
# Validate required bootstrap variables.
# --------------------------------------------------------------------------- #
check_prerequisites() {
  require_cmd docker
  require_value "POSTGRES_USER" "${POSTGRES_USER:-}"
  require_value "POSTGRES_DB" "${POSTGRES_DB:-}"
  require_value "WIKI_ADMIN_EMAIL (WIKI_ADMIN_EMAIL in ${ENV_FILE} or environment)" "${WIKI_ADMIN_EMAIL:-}"
  require_value "WIKI_ADMIN_PASSWORD (WIKI_ADMIN_PASSWORD in ${ENV_FILE} or environment)" "${WIKI_ADMIN_PASSWORD:-}"
}

# --------------------------------------------------------------------------- #
# Build the Docker Compose command array.
# --------------------------------------------------------------------------- #
compose_cmd() {
  echo "docker compose --env-file ${ENV_FILE} -f docker-compose.yml -f deploy/production/docker-compose.production.yml"
}

# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #
main() {
  load_env
  check_prerequisites

  local compose
  compose="$(compose_cmd)"

  # Step 1: Wait for Wiki.js to be ready inside the container.
  log_info "Waiting for Wiki.js to be ready..."
  local max_wait=60
  local attempt=0
  until ${compose} exec -T wikijs wget -q --spider --timeout=10 http://localhost:3000/healthz \
      2>/dev/null \
      || ${compose} exec -T wikijs wget -q --spider --timeout=10 http://localhost:3000/ \
      2>/dev/null; do
    attempt=$((attempt + 1))
    if [[ ${attempt} -ge ${max_wait} ]]; then
      die "Wiki.js did not become healthy after $((max_wait * 5)) seconds. Check: docker compose logs wikijs"
    fi
    log_info "Wiki.js not ready yet (attempt ${attempt}/${max_wait}). Retrying in 5s..."
    sleep 5
  done
  log_success "Wiki.js is ready."

  # Step 2: Seed custom groups into PostgreSQL.
  log_info "Seeding custom groups (Dungeon Master, Player, Viewer)..."
  ${compose} exec -T postgres psql \
    -U "${POSTGRES_USER}" \
    -d "${POSTGRES_DB}" \
    < "${REPO_ROOT}/scripts/bootstrap/seed-groups.sql"
  log_success "Groups seeded."

  # Step 3: Seed starter wiki pages via the GraphQL API.
  log_info "Seeding starter wiki pages..."
  WIKI_ADMIN_EMAIL="${WIKI_ADMIN_EMAIL}" \
  WIKI_ADMIN_PASSWORD="${WIKI_ADMIN_PASSWORD}" \
  WIKI_BASE_URL="${WIKI_BASE_URL:-http://localhost:3000}" \
  bash "${SCRIPT_DIR}/seed-content.sh"
  log_success "Wiki content seeded."

  echo ""
  log_success "Bootstrap complete."
  echo ""
  echo "  ✓ Wiki.js ready"
  echo "  ✓ Groups seeded (Dungeon Master, Player, Viewer)"
  echo "  ✓ Starter pages created"
  echo ""
  echo "Next steps:"
  echo "  1. Open ${WIKI_BASE_URL:-https://167guild.io} and sign in."
  echo "  2. Enable Google OAuth in Administration → Authentication."
  echo "  3. Assign users to groups in Administration → Users."
  echo "  4. Remove WIKI_ADMIN_EMAIL and WIKI_ADMIN_PASSWORD from ${ENV_FILE}."
  echo ""
  echo "See docs/setup/deployment.md for the complete first-boot workflow."
}

main "$@"
