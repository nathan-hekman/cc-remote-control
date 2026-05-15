<p align="center">
  <img src="docs/assets/cc.png" alt="cc-imessage-remote-control logo" width="140">
</p>

<h1 align="center">cc-imessage-remote-control</h1>

<p align="center"><strong>Start Claude on your Mac from a text.</strong></p>

<p align="center">
  <img src="docs/assets/hero-flow-v2.png" alt="Text 'claude ice cream' to yourself; Mac opens Claude Code in the matching project; iOS Claude app shows the live session." width="980">
</p>

---

Claude Code only starts at the Mac. This plugin lets you text **"Claude &lt;project&gt;"** to yourself and have your Mac spin up a `/remote-control` session in that folder — couch, airport, trail, anywhere.

No `chat.db` reading. Native macOS Shortcuts. Sender filter = you. The router never sees a message you didn't text yourself.

## Install

```bash
claude plugin marketplace add nathan-hekman/cc-imessage-remote-control
claude plugin install cc-imessage-remote-control@cc-imessage-remote-control
```

Restart Claude Code, then:

```
/cc-imessage setup
```

5-minute wizard. Writes a per-user config, prints the exact Shortcuts line for your install, walks you through one shortcut + one automation, runs a self-test.

## Day-to-day

| You text          | Mac opens                          |
|-------------------|------------------------------------|
| `Claude eBay`     | `~/Documents/ebay-scrape-new`      |
| `Claude scraper`  | `~/Documents/cy-scraper-new`       |
| `Claude` (alone)  | Texts you the project menu         |

New project? Just `mkdir` it under your projects root. No config change.

## Slash commands

| Command                | What                                     |
|------------------------|------------------------------------------|
| `/cc-imessage setup`   | Interactive setup wizard                 |
| `/cc-imessage status`  | Config + project list + recent logs      |
| `/cc-imessage test`    | Run the router locally, no iMessage      |
| `/cc-imessage tail`    | Last 20 log lines                        |
| `/cc-imessage help`    | Reference card                           |

## More

- [INSTALL.md](INSTALL.md) — install reference, dry-run, uninstall
- [SECURITY.md](SECURITY.md) — threat model, what's not protected
- [`.env.example`](.env.example) — config template

## License

[MIT](LICENSE)
