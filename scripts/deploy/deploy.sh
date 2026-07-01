#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"
# shellcheck source=scripts/common/config.sh
source "${SCRIPT_DIR}/../common/config.sh"

main() {
  require_cmd docker
  require_cmd git

  local env_file="${GUILD_PRODUCTION_ENV_FILE}"
  local compose_file="${GUILD_PRODUCTION_COMPOSE_FILE}"

  [[ -f "${GUILD_REPO_ROOT}/${env_file}" ]] || die "Missing env file: ${env_file}"
  [[ -f "${GUILD_REPO_ROOT}/${compose_file}" ]] || die "Missing compose file: ${compose_file}"

  run_cmd bash "${GUILD_REPO_ROOT}/deploy/scripts/validate-env.sh" "${GUILD_REPO_ROOT}/${env_file}"

  local compose_cmd=(docker compose --env-file "${GUILD_REPO_ROOT}/${env_file}" -f "${GUILD_REPO_ROOT}/docker-compose.yml" -f "${GUILD_REPO_ROOT}/${compose_file}")
  run_cmd "${compose_cmd[@]}" config >/dev/null
  run_cmd "${compose_cmd[@]}" build
  run_cmd "${compose_cmd[@]}" up -d --remove-orphans
  run_cmd bash "${GUILD_REPO_ROOT}/deploy/scripts/health-check.sh" "${GUILD_REPO_ROOT}/${env_file}"

  log_success "Deployment completed successfully."
}

main "$@"
