---
description: "cc-imessage-remote-control controls — interactive setup wizard, status, test ping, log tail. Usage: /cc-imessage setup | status | test | tail | help."
argument-hint: "setup | status | test [phrase] | tail | help"
---

Interpret `$ARGUMENTS` as follows. Match exactly — do not be creative.

If `$ARGUMENTS` is empty or `help`:
- Print a one-line summary of the four sub-commands and stop. Do not invoke any skill.
  ```
  /cc-imessage setup   → interactive setup wizard
  /cc-imessage status  → show config, log path, last few log lines
  /cc-imessage test    → run the router locally with a test phrase
  /cc-imessage tail    → tail the live router log
  ```

If `$ARGUMENTS` is `setup`:
- Invoke the `cc-imessage-setup` skill and follow it. The skill walks
  the user through writing `~/.claude/.cc-imessage-env`, picking the
  Shortcuts shell-script line, opening Shortcuts.app, and verifying the
  install with a self-test.

If `$ARGUMENTS` is `status`:
- Run `bash "${CLAUDE_PLUGIN_ROOT}/bin/build_project_list.sh"` and show the
  user a clean table of slug → path so they can see which projects are
  reachable. Also show:
  - whether `~/.claude/.cc-imessage-env` exists (and its `IMESSAGE_TARGET` / `IMESSAGE_PREFIX` / `ROUTER_MODEL` values, with the phone number masked except the last 4 digits)
  - last 5 lines of `~/.claude/.cc-imessage-logs/router.log` if it exists
  - the absolute path of `claude-router.sh` (i.e. the line the user should have pasted into Shortcuts)

If `$ARGUMENTS` is `test` or `test <phrase>`:
- Default phrase if missing: `Claude help`.
- Run `bash "${CLAUDE_PLUGIN_ROOT}/bin/claude-router.sh" "<phrase>"` in a Bash tool call and report what happened. Surface the log delta produced by this run (`tail -5 ~/.claude/.cc-imessage-logs/router.log`).
- Do not generate a TLDR or HTML one-pager for status/test/tail output — these are operational commands.

If `$ARGUMENTS` is `tail`:
- Run `tail -20 ~/.claude/.cc-imessage-logs/router.log` and show the output verbatim. Then suggest the user run `tail -f` in a real terminal if they want a live feed.

Always end with a single-line pointer to the docs: `Full reference: https://nathan-hekman.github.io/cc-imessage-remote-control/`.
