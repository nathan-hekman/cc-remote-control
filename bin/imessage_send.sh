#!/bin/bash
# Send an iMessage to $IMESSAGE_TARGET, prefixed with $IMESSAGE_PREFIX.
# Adapted from heb-shopping-skill/scripts/imessage_send.sh.

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: $0 \"<message>\"" >&2
  exit 1
fi

target="${IMESSAGE_TARGET:?IMESSAGE_TARGET env var required}"
prefix="${IMESSAGE_PREFIX:-[CR]}"
body="$1"
full="${prefix} ${body}"

escaped=$(printf '%s' "$full" | sed 's/\\/\\\\/g; s/"/\\"/g')

osascript <<EOF
tell application "Messages"
    set targetService to 1st service whose service type = iMessage
    set targetBuddy to buddy "${target}" of targetService
    send "${escaped}" to targetBuddy
end tell
EOF
