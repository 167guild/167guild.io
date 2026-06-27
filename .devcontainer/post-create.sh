#!/usr/bin/env bash
set -euo pipefail

if ! command -v task >/dev/null 2>&1; then
  echo "Installing Task CLI..."
  curl -sL https://taskfile.dev/install.sh | sudo sh -s -- -d -b /usr/local/bin
fi

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y shellcheck shfmt
fi

if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo "Created .env from .env.example"
fi
