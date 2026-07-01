#!/usr/bin/env bash
set -Eeuo pipefail

if [[ -n "${GUILD_CONFIG_LOADED:-}" ]]; then
  return 0
fi
GUILD_CONFIG_LOADED=1

GUILD_REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [[ -n "${GUILD_VERSION:-}" ]]; then
  :
elif git -C "${GUILD_REPO_ROOT}" describe --tags --always >/dev/null 2>&1; then
  GUILD_VERSION="$(git -C "${GUILD_REPO_ROOT}" describe --tags --always)"
else
  GUILD_VERSION="0.0.0-dev"
fi
export GUILD_VERSION

if [[ -z "${GUILD_REPO:-}" ]]; then
  remote_url="$(git -C "${GUILD_REPO_ROOT}" remote get-url origin 2>/dev/null || true)"
  if [[ "${remote_url}" =~ github\.com[:/]([^/]+/[^/.]+)(\.git)?$ ]]; then
    GUILD_REPO="${BASH_REMATCH[1]}"
  else
    GUILD_REPO=""
  fi
fi
export GUILD_REPO

if [[ -z "${GUILD_PROJECT_ID:-}" ]] && command -v gcloud >/dev/null 2>&1; then
  GUILD_PROJECT_ID="$(gcloud config get-value project 2>/dev/null || true)"
  if [[ -n "${GUILD_PROJECT_ID}" && "${GUILD_VERBOSE:-0}" == "1" ]]; then
    if declare -F log_info >/dev/null 2>&1; then
      log_info "Using gcloud default project from local config: ${GUILD_PROJECT_ID}"
    else
      echo "[guild] Using gcloud default project from local config: ${GUILD_PROJECT_ID}" >&2
    fi
  fi
fi

export GUILD_PROJECT_ID="${GUILD_PROJECT_ID:-}"
export GUILD_REGION="${GUILD_REGION:-us-central1}"
export GUILD_ZONE="${GUILD_ZONE:-${GUILD_REGION}-a}"
export GUILD_VM_NAME="${GUILD_VM_NAME:-guild-platform-vm}"
export GUILD_MACHINE_TYPE="${GUILD_MACHINE_TYPE:-e2-medium}"
export GUILD_IP_NAME="${GUILD_IP_NAME:-${GUILD_VM_NAME}-ip}"
export GUILD_NETWORK_TAG="${GUILD_NETWORK_TAG:-guild-web}"
export GUILD_FIREWALL_RULE="${GUILD_FIREWALL_RULE:-${GUILD_VM_NAME}-allow-web}"
export GUILD_SSH_USER="${GUILD_SSH_USER:-$USER}"
export GUILD_DEPLOY_REF="${GUILD_DEPLOY_REF:-main}"
export GUILD_PRODUCTION_ENV_FILE="${GUILD_PRODUCTION_ENV_FILE:-.env.production}"
export GUILD_PRODUCTION_COMPOSE_FILE="${GUILD_PRODUCTION_COMPOSE_FILE:-deploy/production/docker-compose.production.yml}"

# shellcheck disable=SC2034
GUILD_REQUIRED_APIS=(
  compute.googleapis.com
  iam.googleapis.com
  cloudresourcemanager.googleapis.com
)
