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

  if gcloud compute firewall-rules describe "${GUILD_FIREWALL_RULE}" --project "${GUILD_PROJECT_ID}" >/dev/null 2>&1; then
    log_info "Firewall rule already exists: ${GUILD_FIREWALL_RULE}"
  else
    log_info "Creating firewall rule: ${GUILD_FIREWALL_RULE}"
    run_cmd gcloud compute firewall-rules create "${GUILD_FIREWALL_RULE}" \
      --project "${GUILD_PROJECT_ID}" \
      --allow tcp:22,tcp:80,tcp:443 \
      --target-tags "${GUILD_NETWORK_TAG}" \
      --description "Allow SSH and web traffic for guild platform"
  fi

  log_success "Firewall configuration ready."
}

main "$@"
