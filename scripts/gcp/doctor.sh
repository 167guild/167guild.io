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

  log_info "Checking gcloud authentication"
  gcloud auth list --filter=status:ACTIVE --format='value(account)' | grep -q . || die "No active gcloud account. Run: gcloud auth login"

  log_info "Checking project access: ${GUILD_PROJECT_ID}"
  gcloud projects describe "${GUILD_PROJECT_ID}" --format='value(projectId)' >/dev/null

  log_success "GCP doctor checks passed."
}

main "$@"
