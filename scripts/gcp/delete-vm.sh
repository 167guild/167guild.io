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

  local confirm="${1:-}"
  if [[ "${confirm}" != "--yes" ]]; then
    die "Refusing to delete VM without explicit confirmation. Use: guild gcp delete-vm --yes"
  fi

  if gcloud compute instances describe "${GUILD_VM_NAME}" --zone "${GUILD_ZONE}" --project "${GUILD_PROJECT_ID}" >/dev/null 2>&1; then
    run_cmd gcloud compute instances delete "${GUILD_VM_NAME}" --zone "${GUILD_ZONE}" --project "${GUILD_PROJECT_ID}" --quiet
    log_success "VM deleted: ${GUILD_VM_NAME}"
  else
    log_info "VM does not exist: ${GUILD_VM_NAME}"
  fi
}

main "$@"
