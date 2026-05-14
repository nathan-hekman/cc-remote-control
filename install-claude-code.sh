#!/usr/bin/env bash
#
# cc-imessage-remote-control — Claude Code one-liner installer.
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/nathan-hekman/cc-imessage-remote-control/main/install-claude-code.sh)
#
# Clones the repo to a temp dir and runs install.sh. Idempotent — re-runs
# are safe with --force.
#
set -euo pipefail

readonly REPO="nathan-hekman/cc-imessage-remote-control"
readonly BRANCH="${CC_IMESSAGE_BRANCH:-main}"

echo "cc-imessage-remote-control → Claude Code"
echo "  cloning $REPO@$BRANCH"

TMP_DIR="$(mktemp -d -t cc-imessage-remote-control-XXXXXX)"
trap 'rm -rf "$TMP_DIR"' EXIT

git clone --depth 1 --branch "$BRANCH" "https://github.com/$REPO.git" "$TMP_DIR/repo"
"$TMP_DIR/repo/install.sh" --force "$@"

echo
echo "Done. Restart Claude Code, then run /cc-imessage setup."
