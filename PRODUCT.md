# cc-imessage-remote-control — product context

## Register

**brand** — this repo's landing page (`docs/index.html`) and social card are
marketing surfaces for an open-source developer tool. Design IS the product
on those surfaces; the README + INSTALL docs are secondary.

## Users

Developers on **Claude Code Pro/Max plans** who:
- Code on a Mac (macOS 14+)
- Use an iPhone signed into the same iCloud as the Mac
- Want to spin up Claude Code Remote Control sessions from anywhere with
  cell signal — couch, airport, trail — without physically being at the Mac
- Care about privacy. They will not grant Full Disk Access to a third-party
  app to read their iMessage history just to get a remote-trigger feature.

Persona snapshot: solo indie devs, side-project hackers, and shipping-fast
founders. Comfortable with terminals, picky about clean install flows,
allergic to vendor lock-in and "give us access to everything" permission
asks.

## Product purpose

Text yourself "Claude eBay" — your Mac opens a Claude Code session in
that project, Remote Control on, ready to drive from the iOS Claude app.

Existing path required physically being at the Mac to start the session.
This bridge removes that step using **native macOS Shortcuts** as the
trigger gate — no `chat.db` slurp like BlueBubbles or Anthropic's
official iMessage MCP integration require.

## Brand

- **Tone:** upbeat-but-calm. "Yeah, this one's nice." Not rocket-and-
  confetti SaaS holler.
- **Voice:** ELI8 plain words. A twelve-year-old should grok every
  sentence on the landing page.
- **Surfer cadence** allowed (chill, friendly), but never goofy.
- No exclamation marks anywhere. No emoji anywhere.
- One sentence per bullet. One idea per sentence.
- Lead with privacy in every reframe.

## Anti-references

What this landing page must **not** look or sound like:

- **SaaS-rocket-confetti landing pages**: gradient buttons, "10x your
  workflow", testimonial carousels, "Get started free" CTAs that lead
  to a paywall.
- **Cypherpunk-edgy security tools**: black-and-neon, terminal-only
  aesthetics, scary jargon. We're privacy-forward without being
  paranoid.
- **BlueBubbles-style "trust us with your whole iMessage history"
  vibe**: long permission lists, screenshots of TCC dialogs as
  features. Our pitch is the opposite.
- **Default-Tailwind documentation sites**: gray/indigo, sidebar nav,
  H1 + H2 + paragraph pattern every section. Generic open-source vibe.
- **Anthropic / Claude product chrome**: don't ape the official
  marketing aesthetic — this is a community plugin, not first-party.

## Strategic principles

1. **Privacy is the lead pitch.** Every other "iMessage for Claude"
   bridge reads `chat.db`. We don't. This isn't a feature buried in the
   FAQ — it's the headline.
2. **Native is the moat.** macOS Shortcuts is a known, trusted, Apple-
   first-party surface. Use that recognition in the visual language.
3. **Install must look turnkey.** Two `claude plugin` commands +
   `/cc-imessage setup`. Show that, prominently, near the top.
4. **No exaggeration.** The remote-driving experience itself is a
   Claude Code feature — we're the doorbell that wakes it up. Don't
   over-claim. Don't oversell.
5. **Friendly without being childish.** The TiVo-inspired logo and the
   "text yourself a session" framing are warm; the docs are precise.
   Don't let either drift toward the other.

## Surfaces

- `docs/index.html` — GitHub Pages landing. Primary marketing surface.
- `docs/assets/social-card.html` → `social-card.png` — Open Graph /
  Twitter unfurl image (1200×630).
- `docs/assets/logo-mark.svg` + `.png` — brand mark (two CC letters +
  adaptive smile). The smile is dark on light backgrounds, light on
  dark — via `prefers-color-scheme` inside the SVG.
- README.md — secondary; should mirror the landing's voice but tolerate
  more density.

## Out of scope for this document

Per-component design tokens, animation timings, exact spacing scales —
those live in DESIGN.md.
