#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"
# shellcheck source=scripts/common/config.sh
source "${SCRIPT_DIR}/../common/config.sh"

main() {
  local compose_cmd=(docker compose --env-file "${GUILD_REPO_ROOT}/${GUILD_PRODUCTION_ENV_FILE}" -f "${GUILD_REPO_ROOT}/docker-compose.yml" -f "${GUILD_REPO_ROOT}/${GUILD_PRODUCTION_COMPOSE_FILE}")
  run_cmd "${compose_cmd[@]}" ps
}

main "$@"
