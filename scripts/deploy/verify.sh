#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"
# shellcheck source=scripts/common/config.sh
source "${SCRIPT_DIR}/../common/config.sh"

main() {
  run_cmd bash "${GUILD_REPO_ROOT}/deploy/scripts/health-check.sh" "${GUILD_REPO_ROOT}/${GUILD_PRODUCTION_ENV_FILE}"
  log_success "Deployment verification passed."
}

main "$@"
