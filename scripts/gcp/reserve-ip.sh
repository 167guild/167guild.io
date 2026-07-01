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

  if gcloud compute addresses describe "${GUILD_IP_NAME}" --region "${GUILD_REGION}" --project "${GUILD_PROJECT_ID}" >/dev/null 2>&1; then
    log_info "Reserved IP already exists: ${GUILD_IP_NAME}"
  else
    log_info "Creating reserved IP: ${GUILD_IP_NAME}"
    run_cmd gcloud compute addresses create "${GUILD_IP_NAME}" --region "${GUILD_REGION}" --project "${GUILD_PROJECT_ID}"
  fi

  run_cmd gcloud compute addresses describe "${GUILD_IP_NAME}" --region "${GUILD_REGION}" --project "${GUILD_PROJECT_ID}" --format='value(address)'
}

main "$@"
