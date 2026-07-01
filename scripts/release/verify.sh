#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"
# shellcheck source=scripts/common/config.sh
source "${SCRIPT_DIR}/../common/config.sh"

main() {
  local release_workflow="${GUILD_REPO_ROOT}/.github/workflows/release.yml"
  local deploy_workflow="${GUILD_REPO_ROOT}/.github/workflows/deploy-production.yml"

  [[ -f "${release_workflow}" ]] || die "Missing release workflow"
  [[ -f "${deploy_workflow}" ]] || die "Missing deploy workflow"

  grep -q 'googleapis/release-please-action' "${release_workflow}" || die "release.yml missing Release Please action"
  grep -q 'include-v-in-tag' "${GUILD_REPO_ROOT}/.github/release-please-config.json" || die "release-please config missing SemVer tag settings"

  local required_secrets=(PRODUCTION_HOST PRODUCTION_USER PRODUCTION_SSH_KEY)
  local required_vars=(GUILD_PROJECT_ID GUILD_REGION GUILD_ZONE GUILD_VM_NAME)

  log_info "Required GitHub secrets for deployment: $(join_by ', ' "${required_secrets[@]}")"
  log_info "Recommended repository variables for CLI automation: $(join_by ', ' "${required_vars[@]}")"
  log_success "Release verification checks passed."
}

main "$@"
