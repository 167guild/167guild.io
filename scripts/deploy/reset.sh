#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"
# shellcheck source=scripts/common/config.sh
source "${SCRIPT_DIR}/../common/config.sh"

# Execute a command on the remote VM via gcloud SSH.
run_remote() {
  run_cmd gcloud compute ssh "${GUILD_SSH_USER}@${GUILD_VM_NAME}" \
    --project "${GUILD_PROJECT_ID}" \
    --zone "${GUILD_ZONE}" \
    --command "$1"
}

main() {
  require_cmd gcloud
  require_value "GUILD_PROJECT_ID" "${GUILD_PROJECT_ID}"

  local deploy_dir="${GUILD_DEPLOY_DIR}"

  log_warn "Resetting production stack on ${GUILD_VM_NAME}..."
  log_warn "This will stop and remove all project containers, networks, and volumes."
  log_warn "The Git repository and .env.production will be preserved."

  run_remote "
set -Eeuo pipefail
cd '${deploy_dir}'
docker compose --env-file .env.production \
  -f docker-compose.yml \
  -f deploy/production/docker-compose.production.yml \
  down --volumes --remove-orphans
"

  log_success "Reset completed."
  log_success "Repository and .env.production preserved. Ready for a clean deployment."
}

main "$@"
