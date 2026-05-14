---
name: cc-imessage-help
description: Quick-reference card for cc-imessage-remote-control — what it does, how to install, the four slash commands, where files live, the FAQ. One-shot display, not a persistent mode. Trigger when user asks "/cc-imessage-help", "what does cc-imessage do", "how do I use cc-imessage", "imessage router help".
---

# cc-imessage-remote-control — help

Display this reference. One-shot — do NOT change state, write config, or
persist anything. Plain prose so the card reads as a reference.

## What it does

Text yourself `Claude eBay` (or any project name) from your iPhone — your
Mac opens a fresh Terminal window, `cd`s into that project, and starts
`claude --remote-control "<slug>"`. Your Mac then iMessages you back a
confirmation. You open the iOS Claude app → Code tab → tap the new
session entry → drive the Mac from anywhere with cell signal.

## Why this is novel

The Claude iOS app has Remote Control — drive a Mac session from your
phone. But you still had to physically be at the Mac to *start* the
session. This bridge removes that step. **You can spin up a Claude Code
session from the couch, the airport, the trail.**

## Install

```bash
claude plugin marketplace add nathan-hekman/cc-imessage-remote-control
claude plugin install cc-imessage-remote-control@cc-imessage-remote-control
```

Restart Claude Code. Then run `/cc-imessage setup` to wire it into
macOS Shortcuts.

Full docs: https://nathan-hekman.github.io/cc-imessage-remote-control/

## Slash commands

| Command | What |
|---------|------|
| `/cc-imessage setup` | Interactive setup wizard. Writes config, prints the exact Shortcuts shell-script line, opens Shortcuts.app, runs a self-test. |
| `/cc-imessage status` | Shows config, project list, last 5 log lines. Phone number masked. |
| `/cc-imessage test` | Runs the router locally with a test phrase (`Claude`) to verify the reply iMessage works without spawning a session. |
| `/cc-imessage tail` | Last 20 lines of `router.log`. |
| `/cc-imessage help` | This card. |

## Where files live

- **Plugin install:** `~/.claude/plugins/cache/cc-imessage-remote-control/cc-imessage-remote-control/<commit>/`
- **Config:** `~/.claude/.cc-imessage-env` (survives plugin updates)
- **Logs:** `~/.claude/.cc-imessage-logs/router.log`
- **Source:** `bin/claude-router.sh` is the Shortcuts entry point

## FAQ

**Tailscale / same Wi-Fi?** No. iMessage uses Apple's push network; the
Claude Code Remote Control session registers with Anthropic's cloud,
which your iOS Claude app reaches over its own internet. Mac just needs
to be powered on, awake, and signed into iMessage.

**Does this give Claude access to my whole iMessage history?** No. The
Shortcuts filter (`Sender = you` + `Message contains "claude"`) gates
triggering. Only the matched message body is passed to the shell. Haiku
sees that one phrase. Nothing reads `chat.db`.

**Can someone else text my Mac "claude" and run code?** No. The
Shortcuts automation filters on sender — only your own contact card
fires it.

**What does it cost per trigger?** One Claude Haiku 4.5 call (~few
hundred tokens). Well under $0.001 per text. The session itself uses
your normal Claude Code plan.

## Troubleshooting one-liners

- Reply iMessage doesn't arrive → run `bash "${CLAUDE_PLUGIN_ROOT}/bin/imessage_send.sh" "test"` manually (or use the resolved path from `/cc-imessage status`). macOS will prompt for Messages automation permission the first time.
- Automation fires but Terminal doesn't open → check `~/.claude/.cc-imessage-logs/router.log`. Most common: `claude: command not found` because Shortcuts runs without `.zshrc`. Edit the `export PATH=...` line in `claude-router.sh`.
- `infer_project.sh` returns `NONE` every time → run `claude setup-token` to mint a headless OAuth token.
- Trigger doesn't fire → Shortcuts.app → Automation → confirm the automation is toggled **on** at top-right. macOS sometimes disables them after permission prompts.
