#!/bin/bash
# claude-router.sh — entry point invoked by the Shortcuts "Run Shell Script"
# action that fires when an incoming iMessage from you (matching the Sender
# filter you set in Shortcuts) contains the keyword "claude". The Shortcut
# MUST pass the message body as $1.
#
# Flow:
#   1. Load config (~/.claude/.cc-imessage-env, falling back to repo-local .env).
#   2. Drop messages that start with our reply prefix (loop avoidance).
#   3. Strip the leading "Claude" / "claude" keyword off the body.
#   4. Ask infer_project.sh which project slug the remaining phrase points to.
#   5. Open a new Terminal.app window: cd <project> && claude --remote-control.
#   6. Send a confirmation iMessage back.

set -uo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Logs live in the user's Claude config dir so they survive plugin updates.
# Override with CC_IMESSAGE_LOG_DIR if you want them somewhere else.
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
LOG_DIR="${CC_IMESSAGE_LOG_DIR:-$CLAUDE_DIR/.cc-imessage-logs}"
mkdir -p "$LOG_DIR" 2>/dev/null || LOG_DIR="$PROJECT_DIR/logs" && mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/router.log"

# zsh / non-interactive Shortcuts shells don't load .zshrc. Make sure
# `claude` and `osascript` are findable.
export PATH="$HOME/.local/bin:$HOME/.claude/local:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# Load config. Search order:
#   1. $CC_IMESSAGE_ENV (explicit override)
#   2. $CLAUDE_CONFIG_DIR/.cc-imessage-env  (preferred — survives plugin updates)
#   3. $PROJECT_DIR/.env                          (dev fallback — repo-local)
load_env() {
  local f="$1"
  [ -f "$f" ] || return 1
  set -a
  # shellcheck disable=SC1090
  source "$f"
  set +a
  log "loaded config: $f"
  return 0
}

if [ -n "${CC_IMESSAGE_ENV:-}" ] && load_env "$CC_IMESSAGE_ENV"; then
  :
elif load_env "$CLAUDE_DIR/.cc-imessage-env"; then
  :
elif load_env "$PROJECT_DIR/.env"; then
  :
else
  log "WARN: no config file found — using defaults"
fi

SEND="$PROJECT_DIR/bin/imessage_send.sh"
INFER="$PROJECT_DIR/bin/infer_project.sh"
LIST="$PROJECT_DIR/bin/build_project_list.sh"
PREFIX="${IMESSAGE_PREFIX:-[CR]}"

msg="${1:-}"
# Fall back to stdin in case the Shortcut's "Run Shell Script" action is
# configured to pipe input rather than pass it as argv.
if [ -z "$msg" ] && [ ! -t 0 ]; then
  msg="$(cat)"
fi
log "received: $msg"

if [ -z "$msg" ]; then
  log "empty message; nothing to do"
  exit 0
fi

# Loop avoidance: ignore any message that starts with our reply prefix.
case "$msg" in
  "$PREFIX"*)
    log "ignored: matches reply prefix"
    exit 0
    ;;
esac

# Strip leading "Claude" / "claude" (case-insensitive) plus any trailing
# punctuation/whitespace.
phrase=$(printf '%s' "$msg" \
  | sed -E 's/^[[:space:]]*[Cc][Ll][Aa][Uu][Dd][Ee][[:space:][:punct:]]*//' \
  | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')
log "phrase: '$phrase'"

if [ -z "$phrase" ]; then
  available=$("$LIST" | cut -d'|' -f1 | head -10 | paste -sd, -)
  "$SEND" "Which project? Try one of: $available" || true
  log "empty phrase; sent menu"
  exit 0
fi

# Ask Haiku.
slug=$("$INFER" "$phrase" 2>>"$LOG_FILE")
log "infer → $slug"

if [ -z "$slug" ] || [ "$slug" = "NONE" ]; then
  available=$("$LIST" | cut -d'|' -f1 | head -10 | paste -sd, -)
  "$SEND" "Couldn't match '$phrase'. Try: $available" || true
  exit 0
fi

# Look up the directory path for the slug.
path=$("$LIST" | awk -F'|' -v s="$slug" '$1==s {print $2; exit}')
if [ -z "$path" ]; then
  "$SEND" "Matched '$slug' but no path found. Check build_project_list.sh." || true
  log "ERROR: no path for slug $slug"
  exit 1
fi

# Escape for AppleScript: backslash and double-quote only.
escaped_path=$(printf '%s' "$path" | sed 's/\\/\\\\/g; s/"/\\"/g')
WINDOW_TITLE="Claude — $slug"

# Open a new Terminal window, cd into the project, and start an interactive
# claude session with Remote Control on. The session name passed to
# --remote-control is what shows up in the iOS Claude app under Code.
osascript <<APPLESCRIPT
tell application "Terminal"
    activate
    set newTab to do script "cd \"$escaped_path\" && claude --remote-control \"$slug\""
    delay 0.3
    set custom title of newTab to "$WINDOW_TITLE"
end tell
APPLESCRIPT

"$SEND" "Session started in $slug. Open the Claude app to continue." || true
log "launched: $slug at $path"
