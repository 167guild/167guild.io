#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"
# shellcheck source=scripts/common/config.sh
source "${SCRIPT_DIR}/../common/config.sh"

main() {
  require_cmd git

  log_info "Updating repository to ${GUILD_DEPLOY_REF}"
  run_cmd git -C "${GUILD_REPO_ROOT}" fetch --tags origin
  run_cmd git -C "${GUILD_REPO_ROOT}" checkout "${GUILD_DEPLOY_REF}"

  if git -C "${GUILD_REPO_ROOT}" rev-parse --verify "refs/remotes/origin/${GUILD_DEPLOY_REF}" >/dev/null 2>&1; then
    run_cmd git -C "${GUILD_REPO_ROOT}" pull origin "${GUILD_DEPLOY_REF}" --ff-only
  fi

  run_cmd bash "${SCRIPT_DIR}/deploy.sh"
  log_success "Redeploy completed."
}

main "$@"
