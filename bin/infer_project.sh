#!/bin/bash
# Map a short phrase to a project slug via a small Claude model.
# Usage: infer_project.sh "<phrase>"
# Stdout: one slug, or "NONE".

set -uo pipefail

phrase="${1:-}"
if [ -z "$phrase" ]; then
  echo "NONE"
  exit 0
fi

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LIST_SCRIPT="$PROJECT_DIR/bin/build_project_list.sh"
MODEL="${ROUTER_MODEL:-claude-haiku-4-5-20251001}"

# Non-interactive `claude -p` needs the long-lived headless OAuth token
# (set up once with `claude setup-token`). When this script is invoked
# from inside another Claude Code session the parent injects
# ANTHROPIC_API_KEY / ANTHROPIC_BASE_URL pointing at the session's
# managed proxy — those creds aren't valid for normal CLI use, so wipe
# them and let the headless token take over.
unset ANTHROPIC_API_KEY ANTHROPIC_BASE_URL ANTHROPIC_AUTH_TOKEN CLAUDE_CODE_OAUTH_TOKEN
HEADLESS_TOKEN_FILE="$HOME/.claude-headless-token"
if [ -f "$HEADLESS_TOKEN_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  source "$HEADLESS_TOKEN_FILE"
  set +a
fi

# Build the slug enum for the prompt.
slug_list=$("$LIST_SCRIPT" | cut -d'|' -f1 | sort -u | paste -sd, -)

read -r -d '' prompt <<EOF || true
You map a short user phrase to ONE project slug from a fixed list, or "NONE" if nothing fits.

Valid slugs: $slug_list

Phrase: "$phrase"

Hints:
- "ebay" / "ebay-scrape" / "scrape" → ebay-scrape-new
- "cy" / "courtyard" / "cy-scraper" → cy-scraper-new
- "server" / "scrape-server" / "hub" → scrape-server
- "ios" / "safari extension" / "ios extension" → ios-psa-cert-lookup-extension
- "chrome" / "chrome extension" → psa-cert-lookup-chrome-extension
- "psa-shared" / "shared" → psa-shared

Reply with exactly one slug from the list (or the literal word NONE).
No quotes, no punctuation, no explanation, no other text.
EOF

# `claude -p` runs non-interactively; output is the model's reply.
# Strip whitespace and any stray quoting.
result=$(claude -p --model "$MODEL" "$prompt" 2>/dev/null \
  | tr -d '"' \
  | tr -d "'" \
  | tr -d '[:space:]')

# Validate against the slug list to avoid hallucinated slugs.
if [ -z "$result" ] || [ "$result" = "NONE" ]; then
  echo "NONE"
  exit 0
fi

if "$LIST_SCRIPT" | cut -d'|' -f1 | grep -Fxq "$result"; then
  echo "$result"
else
  echo "NONE"
fi
