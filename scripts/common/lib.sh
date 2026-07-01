#!/usr/bin/env bash
set -Eeuo pipefail

if [[ -n "${GUILD_LIB_LOADED:-}" ]]; then
  return 0
fi
GUILD_LIB_LOADED=1

if [[ "${GUILD_NO_COLOR:-0}" == "1" || ! -t 1 ]]; then
  C_RESET=""
  C_RED=""
  C_GREEN=""
  C_YELLOW=""
  C_BLUE=""
else
  C_RESET='\033[0m'
  C_RED='\033[31m'
  C_GREEN='\033[32m'
  C_YELLOW='\033[33m'
  C_BLUE='\033[34m'
fi

log_info() { echo -e "${C_BLUE}[guild]${C_RESET} $*"; }
log_warn() { echo -e "${C_YELLOW}[guild]${C_RESET} $*"; }
log_error() { echo -e "${C_RED}[guild]${C_RESET} $*" >&2; }
log_success() { echo -e "${C_GREEN}[guild]${C_RESET} $*"; }

die() {
  log_error "$*"
  exit 1
}

require_cmd() {
  local cmd="$1"
  command -v "${cmd}" >/dev/null 2>&1 || die "Required command not found: ${cmd}"
}

require_value() {
  local name="$1"
  local value="$2"
  [[ -n "${value}" ]] || die "Missing required value: ${name}"
}

run_cmd() {
  if [[ "${GUILD_VERBOSE:-0}" == "1" ]]; then
    log_info "Running: $*"
  fi
  "$@"
}

join_by() {
  local delimiter="$1"
  shift
  local output="${1:-}"
  shift || true
  for item in "$@"; do
    output+="${delimiter}${item}"
  done
  echo "${output}"
}
