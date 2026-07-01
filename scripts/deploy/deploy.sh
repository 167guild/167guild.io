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

# Execute a silent boolean test on the remote VM.
# Returns 0 if the test succeeds, non-zero otherwise.
# Suppresses all output to keep log output clean.
remote_test() {
  gcloud compute ssh "${GUILD_SSH_USER}@${GUILD_VM_NAME}" \
    --project "${GUILD_PROJECT_ID}" \
    --zone "${GUILD_ZONE}" \
    --command "$1" \
    >/dev/null 2>&1
}

# Upload a local file to the remote VM via gcloud SCP.
upload_to_remote() {
  local local_src="$1"
  local remote_dest="$2"
  run_cmd gcloud compute scp "${local_src}" \
    "${GUILD_SSH_USER}@${GUILD_VM_NAME}:${remote_dest}" \
    --project "${GUILD_PROJECT_ID}" \
    --zone "${GUILD_ZONE}"
}

main() {
  require_cmd gcloud
  require_value "GUILD_PROJECT_ID" "${GUILD_PROJECT_ID}"
  require_value "GUILD_REPO" "${GUILD_REPO}"

  local deploy_dir="${GUILD_DEPLOY_DIR}"
  local deploy_ref="${GUILD_DEPLOY_REF}"
  local remote_env_file="${deploy_dir}/.env.production"
  local local_env_file="${GUILD_REPO_ROOT}/${GUILD_PRODUCTION_ENV_FILE}"
  local clone_url="https://github.com/${GUILD_REPO}.git"

  log_info "Connecting to production VM..."

  # Step 1: Remote bootstrap or repository sync
  # Note: local variables (deploy_dir, deploy_ref, clone_url) are expanded before
  # the command string is sent to the remote shell; single-quoted values protect
  # the expanded result from further remote-shell interpretation.
  if remote_test "test -d '${deploy_dir}/.git'"; then
    log_info "Repository found."
    log_info "Updating repository..."
    run_remote "
set -Eeuo pipefail
cd '${deploy_dir}'
git fetch origin
git checkout ${deploy_ref}
if git rev-parse --verify refs/remotes/origin/${deploy_ref} >/dev/null 2>&1; then
  git pull --ff-only origin ${deploy_ref}
fi
"
    log_success "Repository updated."
  else
    log_info "Repository not found. Bootstrapping deployment directory..."
    run_remote "
set -Eeuo pipefail
sudo mkdir -p '${deploy_dir}'
sudo chown \"\$(id -un):\$(id -gn)\" '${deploy_dir}'
git clone '${clone_url}' '${deploy_dir}'
cd '${deploy_dir}'
git checkout ${deploy_ref}
"
    log_success "Repository bootstrapped."
  fi

  # Step 2: Environment management
  if remote_test "test -f '${remote_env_file}'"; then
    log_info "Environment verified."
  else
    log_info "Environment file not found on remote. Checking for local copy..."
    if [[ ! -f "${local_env_file}" ]]; then
      die "Missing ${GUILD_PRODUCTION_ENV_FILE}.
Create it from deploy/examples/.env.production.example with production values:
  cp deploy/examples/.env.production.example .env.production
  # Edit .env.production with real credentials
Then retry: ./guild deploy"
    fi
    log_info "Uploading environment to remote..."
    upload_to_remote "${local_env_file}" "${remote_env_file}"
    log_success "Environment uploaded."
  fi

  # Step 3: Remote deployment
  log_info "Deploying containers..."
  run_remote "
set -Eeuo pipefail
cd '${deploy_dir}'
task deploy:production
"

  # Step 4: Remote health checks
  log_info "Running health checks..."
  run_remote "
set -Eeuo pipefail
cd '${deploy_dir}'
task health
"

  # Step 5: Deployment summary.
  # This block is only reached when all previous steps — including health checks —
  # completed successfully. set -Eeuo pipefail ensures the script exits immediately
  # on any failure, so these status lines accurately reflect the completed deployment.
  echo ""
  log_success "Deployment Complete"
  echo ""
  echo "  ✓ Repository updated"
  echo "  ✓ Environment loaded"
  echo "  ✓ Docker Compose deployed"
  echo "  ✓ PostgreSQL healthy"
  echo "  ✓ Wiki.js healthy"
  echo "  ✓ Caddy healthy"
  echo ""
  echo "  Application: https://${GUILD_DOMAIN}"
}

main "$@"
