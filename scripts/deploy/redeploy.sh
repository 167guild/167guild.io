#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"
# shellcheck source=scripts/common/config.sh
source "${SCRIPT_DIR}/../common/config.sh"

main() {
  log_info "Redeploying to ${GUILD_DEPLOY_REF}..."
  run_cmd bash "${SCRIPT_DIR}/reset.sh" "$@"
  run_cmd bash "${SCRIPT_DIR}/deploy.sh" "$@"
  log_success "Redeploy completed."
}

main "$@"
