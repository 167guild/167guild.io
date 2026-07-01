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

  run_cmd gcloud compute ssh "${GUILD_SSH_USER}@${GUILD_VM_NAME}" --project "${GUILD_PROJECT_ID}" --zone "${GUILD_ZONE}" --command "set -Eeuo pipefail; sudo apt-get update && sudo apt-get upgrade -y"
  log_success "VM package update complete."
}

main "$@"
