#!/usr/bin/env bash
set -euo pipefail

mkdir -p "${HOME}/.local/bin"
export PATH="${HOME}/.local/bin:${PATH}"

if ! command -v task >/dev/null 2>&1; then
  echo "Installing Task CLI..."
  install_script="$(mktemp)"
  curl -fsSL https://taskfile.dev/install.sh -o "${install_script}"
  sh "${install_script}" -d -b "${HOME}/.local/bin"
  rm -f "${install_script}"
fi

if command -v apt-get >/dev/null 2>&1; then
  echo "Installing shellcheck and shfmt..."
  sudo apt-get update
  sudo apt-get install -y shellcheck shfmt
fi

if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo "Created .env from .env.example"
fi
