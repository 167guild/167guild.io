#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"
# shellcheck source=scripts/common/config.sh
source "${SCRIPT_DIR}/../common/config.sh"

main() {
  local missing=0

  for required_path in \
    ".github/workflows/release.yml" \
    ".github/release-please-config.json" \
    ".release-please-manifest.json" \
    ".commitlintrc.mjs"; do
    if [[ -f "${GUILD_REPO_ROOT}/${required_path}" ]]; then
      log_success "Found ${required_path}"
    else
      log_error "Missing ${required_path}"
      missing=$((missing + 1))
    fi
  done

  if [[ ${missing} -gt 0 ]]; then
    die "Release doctor found ${missing} issue(s)."
  fi

  log_success "Release doctor checks passed."
}

main "$@"
