# cc-imessage-remote-control — install reference

## Pure Claude Code commands (recommended)

```bash
claude plugin marketplace add nathan-hekman/cc-imessage-remote-control
claude plugin install cc-imessage-remote-control@cc-imessage-remote-control
```

That clones the marketplace into `$CLAUDE_CONFIG_DIR/plugins/marketplaces/cc-imessage-remote-control/`, installs the plugin into `$CLAUDE_CONFIG_DIR/plugins/cache/cc-imessage-remote-control/cc-imessage-remote-control/<commit>/`, and registers it so it shows up in `/plugin list` and in the Claude Code desktop UI.

Restart Claude Code, then:

```
/cc-imessage setup
```

The setup wizard walks you through writing the config, picking the exact Shortcuts shell-script line for your install, opening Shortcuts.app, and verifying the install with a self-test ping. **5 minutes start to finish.**

## One-line install (curl | bash)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/nathan-hekman/cc-imessage-remote-control/main/install-claude-code.sh)
```

Clones the repo to a temp dir and runs `install.sh --force`. Same end state as the two `claude plugin` commands above. Idempotent — safe to re-run.

## Local clone install

```bash
git clone https://github.com/nathan-hekman/cc-imessage-remote-control.git
cd cc-imessage-remote-control
./install.sh                  # plugin install + next-step pointer
./install.sh --plugin-only    # plugin only, skip the nudge
./install.sh --dry-run        # preview, write nothing
./install.sh --force          # re-run even if already installed
```

## Prerequisites

| Thing | Why | How to get it |
|------|-----|---------------|
| **macOS 14 (Sonoma) or newer** | Shortcuts Personal Automations + AppleScript Messages support | Already on your Mac if recent |
| **iPhone signed into same iCloud as Mac** | "Sender = me" filter matches; Mac can iMessage you back | Settings → [your name] → iCloud |
| **iMessage active on both devices** | Trigger + reply channel | Messages → Settings → iMessage tab |
| **Claude Code (Pro or Max plan)** | Remote Control is a Pro/Max feature | [claude.com/claude-code](https://claude.com/claude-code) |
| **Claude Code headless OAuth token** | Lets the router call `claude -p` non-interactively from a Shortcut | Run `claude setup-token` once |
| **Your phone number in E.164 format** | Reply target (e.g. `+15551234567`) | You already know it |

## What gets installed where

| Path | Purpose |
|------|---------|
| `$CLAUDE_CONFIG_DIR/plugins/cache/cc-imessage-remote-control/cc-imessage-remote-control/<commit>/` | Plugin install (scripts, hooks, skills, commands) |
| `$CLAUDE_CONFIG_DIR/.cc-imessage-env` | Your config (phone number, prefix, model, project roots) |
| `$CLAUDE_CONFIG_DIR/.cc-imessage-logs/router.log` | Append-only run log |
| `$CLAUDE_CONFIG_DIR/.cc-imessage-update-available` | Sentinel — written by update-check hook when a newer release exists |

`$CLAUDE_CONFIG_DIR` defaults to `~/.claude`.

## Updating

```bash
claude plugin update cc-imessage-remote-control@cc-imessage-remote-control
```

Your config (`.cc-imessage-env`) and logs live outside the plugin cache, so they survive updates automatically.

## Uninstalling

```bash
claude plugin uninstall cc-imessage-remote-control@cc-imessage-remote-control
```

That removes the plugin from `$CLAUDE_CONFIG_DIR/plugins/cache/`. To fully clean up:

```bash
rm -f ~/.claude/.cc-imessage-env ~/.claude/.cc-imessage-update-* ~/.claude/.cc-imessage-active
rm -rf ~/.claude/.cc-imessage-logs
```

Then open Shortcuts.app and delete the **Run claude launcher** shortcut and the **Message → claude** automation.

## Mobile mode prerequisites

None. The "mobile" experience here is just iMessage on your iPhone — no GitHub Pages, no separate publish step. You text your Mac; your Mac texts you back. The iOS Claude app handles the Remote Control side.
