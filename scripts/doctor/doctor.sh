#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"
# shellcheck source=scripts/common/config.sh
source "${SCRIPT_DIR}/../common/config.sh"

main() {
  local missing=0

  log_info "Running local platform diagnostics"

  for cmd in bash git docker; do
    if command -v "${cmd}" >/dev/null 2>&1; then
      log_success "Found command: ${cmd}"
    else
      log_error "Missing command: ${cmd}"
      missing=$((missing + 1))
    fi
  done

  if command -v task >/dev/null 2>&1; then
    log_success "Found command: task"
  else
    log_warn "Task CLI is not installed (some workflows may require it)"
  fi

  if [[ -f "${GUILD_REPO_ROOT}/docker-compose.yml" ]]; then
    log_success "Found docker-compose.yml"
  else
    log_error "Missing docker-compose.yml"
    missing=$((missing + 1))
  fi

  if [[ -f "${GUILD_REPO_ROOT}/${GUILD_PRODUCTION_COMPOSE_FILE}" ]]; then
    log_success "Found ${GUILD_PRODUCTION_COMPOSE_FILE}"
  else
    log_error "Missing ${GUILD_PRODUCTION_COMPOSE_FILE}"
    missing=$((missing + 1))
  fi

  if [[ ${missing} -gt 0 ]]; then
    die "Doctor found ${missing} blocking issue(s)."
  fi

  log_success "Doctor checks passed."
}

main "$@"
