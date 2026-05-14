# Security model, cc-imessage-remote-control

## What this bridge does in security terms

`cc-imessage-remote-control` accepts a single iMessage on your Mac, matches it against a Shortcuts filter, then spawns a Terminal window running `claude --remote-control` in one of your project directories. It is **not** a remote shell. It does **not** parse the message as code. It maps the message body to one of a fixed list of project slugs (your own folder names) via a Claude Haiku classification.

## Threat model

| Threat | Mitigated by | Status |
|--------|--------------|--------|
| Someone else triggers your Mac by texting it "claude" | macOS Shortcuts automation filter: `Sender = <your contact>`. Messages from anyone else are ignored before the shell ever runs. | Mitigated |
| Attacker injects shell metacharacters via the message body | The message body is **not** executed. It is passed as `$1` to a shell that uses it only as a prompt to Claude Haiku. Haiku is then constrained to return one slug from a fixed list of your folder names, anything else returns `NONE`. | Mitigated |
| Attacker tricks Haiku into returning a path outside your projects | `infer_project.sh` validates Haiku's response against the slug list built from `build_project_list.sh` (a strict directory enumeration). Hallucinated slugs return `NONE`. | Mitigated |
| Reply iMessage loop (Mac iMessages itself triggering the automation again) | (a) Personal Automation on macOS doesn't fire on Mac-originated messages. (b) Belt-and-suspenders: every reply is prefixed with `IMESSAGE_PREFIX` (default `[CR]`), and incoming messages starting with that prefix are dropped before infer runs. | Mitigated |
| Phone number leaked via plugin install | Config (`.cc-imessage-env`) lives in `$CLAUDE_CONFIG_DIR`, **not** in the plugin cache. It is `chmod 600` after the setup wizard writes it. It is never sent over the network. | Mitigated |
| Full iMessage history exfiltration | The router has access to one message at a time, the body of the matched message, passed as `$1`. It never reads `chat.db` or any other Messages storage. | Mitigated |
| Compromised plugin update ships malicious code | Plugins install from a git repo via `claude plugin install`. You can pin a specific commit by editing `installed_plugins.json`, and you can audit the diff with `git log` in the marketplace cache. | Partial, relies on you trusting this repo |

## Limits, what this does NOT protect against

- A malicious actor with physical Mac access. Plugin code is on disk, the OAuth token is on disk.
- A compromised Anthropic Claude Code install. If `claude` itself is malicious, the bridge is the least of your concerns.
- A jailbroken iPhone where someone else can read your iMessages.

## Reporting issues

If you find a security issue, please **do not** open a public GitHub issue. Open a [private GitHub Security Advisory](https://github.com/nathan-hekman/cc-imessage-remote-control/security/advisories/new) instead, that's the preferred channel. As a fallback you can reach the author at the email listed on [github.com/nathan-hekman](https://github.com/nathan-hekman).

## Auth / credentials reference

| Credential | Where stored | Who can read it |
|-----------|--------------|------------------|
| Claude Code OAuth (headless) | `~/.claude-headless-token` | Your macOS user account |
| Phone number (`IMESSAGE_TARGET`) | `~/.claude/.cc-imessage-env` (mode 600) | Your macOS user account |
| Messages.app automation permission | macOS Privacy & Security → Automation | Granted once via TCC prompt |
