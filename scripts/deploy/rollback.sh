#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"
# shellcheck source=scripts/common/config.sh
source "${SCRIPT_DIR}/../common/config.sh"

main() {
  require_cmd git
  local rollback_ref="${1:-${GUILD_ROLLBACK_REF:-}}"
  [[ -n "${rollback_ref}" ]] || die "Usage: guild rollback <git-ref>"

  log_info "Fetching rollback ref: ${rollback_ref}"
  run_cmd git -C "${GUILD_REPO_ROOT}" fetch --tags origin

  local current_ref
  current_ref="$(git -C "${GUILD_REPO_ROOT}" rev-parse --abbrev-ref HEAD)"

  run_cmd git -C "${GUILD_REPO_ROOT}" checkout "${rollback_ref}"
  if ! bash "${SCRIPT_DIR}/deploy.sh"; then
    log_warn "Rollback deploy failed. Attempting to restore previous ref: ${current_ref}"
    git -C "${GUILD_REPO_ROOT}" checkout "${current_ref}" || true
    exit 1
  fi

  log_success "Rollback deploy completed for ${rollback_ref}"
}

main "$@"
