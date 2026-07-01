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
    gcloud compute addresses describe "${GUILD_IP_NAME}" --region "${GUILD_REGION}" --project "${GUILD_PROJECT_ID}" --format='value(address)'
    return 0
  fi

  gcloud compute instances describe "${GUILD_VM_NAME}" --zone "${GUILD_ZONE}" --project "${GUILD_PROJECT_ID}" --format='value(networkInterfaces[0].accessConfigs[0].natIP)'
}

main "$@"
