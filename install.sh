#!/usr/bin/env bash

# ==============================================================================
# Remote One-Liner Installer for Antigravity Multi-Agent Team Template
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/TrangDuyNguyen/antigravity-agent-team-template/main/install.sh | bash
# ==============================================================================

set -euo pipefail

REPO_URL="https://github.com/TrangDuyNguyen/antigravity-agent-team-template.git"
TEMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "${TEMP_DIR}"
}
trap cleanup EXIT

echo "==> Fetching Antigravity Multi-Agent Team Template from GitHub..."
git clone --depth 1 "${REPO_URL}" "${TEMP_DIR}/repo" 2>/dev/null || {
  echo "Error: Failed to clone template from ${REPO_URL}. Please check internet connection or repo access." >&2
  exit 1
}

# Run setup.sh from the cloned repo pointing to current directory
bash "${TEMP_DIR}/repo/setup.sh" --dir "${PWD}" "$@"
