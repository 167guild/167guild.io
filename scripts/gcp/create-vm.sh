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

  if gcloud compute instances describe "${GUILD_VM_NAME}" --zone "${GUILD_ZONE}" --project "${GUILD_PROJECT_ID}" >/dev/null 2>&1; then
    log_info "VM already exists: ${GUILD_VM_NAME}"
    return 0
  fi

  local ip_args=()
  if gcloud compute addresses describe "${GUILD_IP_NAME}" --region "${GUILD_REGION}" --project "${GUILD_PROJECT_ID}" >/dev/null 2>&1; then
    ip_args=(--address "${GUILD_IP_NAME}")
    log_info "Using reserved IP: ${GUILD_IP_NAME}"
  else
    log_warn "Reserved IP ${GUILD_IP_NAME} not found; VM will get ephemeral IP"
  fi

  log_info "Creating VM ${GUILD_VM_NAME} in ${GUILD_ZONE}"
  if [[ ${#ip_args[@]} -gt 0 ]]; then
    run_cmd gcloud compute instances create "${GUILD_VM_NAME}" \
      --project "${GUILD_PROJECT_ID}" \
      --zone "${GUILD_ZONE}" \
      --machine-type "${GUILD_MACHINE_TYPE}" \
      --image-family ubuntu-2204-lts \
      --image-project ubuntu-os-cloud \
      --boot-disk-size 30GB \
      --tags "${GUILD_NETWORK_TAG}" \
      "${ip_args[@]}"
  else
    run_cmd gcloud compute instances create "${GUILD_VM_NAME}" \
      --project "${GUILD_PROJECT_ID}" \
      --zone "${GUILD_ZONE}" \
      --machine-type "${GUILD_MACHINE_TYPE}" \
      --image-family ubuntu-2204-lts \
      --image-project ubuntu-os-cloud \
      --boot-disk-size 30GB \
      --tags "${GUILD_NETWORK_TAG}"
  fi

  log_success "VM created: ${GUILD_VM_NAME}"
}

main "$@"
