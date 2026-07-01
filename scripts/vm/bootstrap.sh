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

  local bootstrap_script
  bootstrap_script="$(cat <<'REMOTE'
set -Eeuo pipefail
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release git ufw

if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
fi

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker "${USER}" || true

if docker compose version >/dev/null 2>&1; then
  :
elif command -v docker-compose >/dev/null 2>&1; then
  :
else
  sudo apt-get install -y docker-compose-plugin
fi

if ! command -v task >/dev/null 2>&1; then
  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b "$HOME/.local/bin"
fi

sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

echo "VM bootstrap completed."
REMOTE
)"

  run_cmd gcloud compute ssh "${GUILD_SSH_USER}@${GUILD_VM_NAME}" --project "${GUILD_PROJECT_ID}" --zone "${GUILD_ZONE}" --command "${bootstrap_script}"
  log_success "VM bootstrap completed."
}

main "$@"
