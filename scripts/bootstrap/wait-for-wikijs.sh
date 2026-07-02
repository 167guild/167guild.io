#!/usr/bin/env bash
# =============================================================================
# wait-for-wikijs.sh — Wait until Wiki.js is ready to accept requests.
# =============================================================================
#
# Polls the Wiki.js health endpoint until a successful response is returned.
# Exits non-zero if Wiki.js does not become ready within the timeout.
#
# Usage:
#   bash scripts/bootstrap/wait-for-wikijs.sh [URL] [MAX_ATTEMPTS]
#
# Environment variables (override defaults):
#   WIKI_BASE_URL     URL of the Wiki.js instance (default: http://localhost:3000)
#   WIKI_MAX_ATTEMPTS Maximum poll attempts (default: 60)
#   WIKI_SLEEP        Seconds between attempts (default: 5)
#
# Arguments (take precedence over environment variables):
#   URL           Wiki.js base URL
#   MAX_ATTEMPTS  Maximum number of attempts before failing
#
# Example:
#   bash scripts/bootstrap/wait-for-wikijs.sh http://localhost:3000 60
# =============================================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"

WIKIJS_URL="${1:-${WIKI_BASE_URL:-http://localhost:3000}}"
MAX_ATTEMPTS="${2:-${WIKI_MAX_ATTEMPTS:-60}}"
SLEEP_INTERVAL="${WIKI_SLEEP:-5}"

main() {
  log_info "Waiting for Wiki.js at ${WIKIJS_URL} (max $((MAX_ATTEMPTS * SLEEP_INTERVAL))s)..."

  local attempt=0
  until wget -q --spider --timeout=10 "${WIKIJS_URL}/healthz" 2>/dev/null \
      || wget -q --spider --timeout=10 "${WIKIJS_URL}/" 2>/dev/null; do
    attempt=$((attempt + 1))
    if [[ ${attempt} -ge ${MAX_ATTEMPTS} ]]; then
      die "Wiki.js did not become ready after $((MAX_ATTEMPTS * SLEEP_INTERVAL)) seconds at ${WIKIJS_URL}."
    fi
    log_info "Wiki.js not ready yet (attempt ${attempt}/${MAX_ATTEMPTS}). Retrying in ${SLEEP_INTERVAL}s..."
    sleep "${SLEEP_INTERVAL}"
  done

  log_success "Wiki.js is ready."
}

main "$@"
