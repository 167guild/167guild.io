#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"
# shellcheck source=scripts/common/config.sh
source "${SCRIPT_DIR}/../common/config.sh"

main() {
  require_cmd gcloud
  require_value "GUILD_PROJECT_ID" "${GUILD_PROJECT_ID}"

  log_info "Enabling required APIs for project ${GUILD_PROJECT_ID}"
  run_cmd gcloud services enable --project "${GUILD_PROJECT_ID}" "${GUILD_REQUIRED_APIS[@]}"
  log_success "Required APIs enabled."
}

main "$@"
