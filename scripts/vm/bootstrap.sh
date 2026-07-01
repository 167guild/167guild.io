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
sudo apt-get install -y ca-certificates curl gnupg lsb-release git ufw tar

if ! command -v docker >/dev/null 2>&1; then
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
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
  TASK_VERSION="3.39.2"
  TASK_ARCH="$(uname -m)"
  case "${TASK_ARCH}" in
    x86_64) TASK_ARCH="amd64" ;;
    aarch64|arm64) TASK_ARCH="arm64" ;;
    *) echo "Unsupported architecture for Task install: ${TASK_ARCH}" >&2; exit 1 ;;
  esac
  TASK_ARCHIVE="task_linux_${TASK_ARCH}.tar.gz"
  TASK_BASE_URL="https://github.com/go-task/task/releases/download/v${TASK_VERSION}"
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "${TMP_DIR}"' EXIT
  curl -fsSL "${TASK_BASE_URL}/${TASK_ARCHIVE}" -o "${TMP_DIR}/${TASK_ARCHIVE}"
  curl -fsSL "${TASK_BASE_URL}/task_checksums.txt" -o "${TMP_DIR}/task_checksums.txt"
  (
    cd "${TMP_DIR}"
    grep " ${TASK_ARCHIVE}\$" task_checksums.txt | sha256sum --check
  )
  sudo tar -xzf "${TMP_DIR}/${TASK_ARCHIVE}" -C /usr/local/bin task
  sudo chmod +x /usr/local/bin/task
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
