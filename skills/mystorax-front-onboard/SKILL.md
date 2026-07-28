---
name: mystorax-front-onboard
description: >
  Onboard any MystoraX front (Cursor, Claude Code, Claude Science, Codex, ChatGPT Actions, HTTP).
  Use on first connect or when a host cannot find Conductor tools. Equal steps for every front — never Claude-Science-only.
---

# MystoraX Front Onboard

Read `FRONT_ONBOARD.md` in this pack. All fronts share one Conductor.

## Checklist (every front)

1. Set `MYSTORAX_CONDUCTOR_URL` + `MYSTORAX_HOST_TOKEN`
2. Discover: routing guide → surfaces → manifest
3. Prefer `mystorax_submit_goal` / `POST /v1/goal`
4. Science: stop at EVIDENCE; never auto-CERTIFY
5. Refuse Computer / ASI / Spark / local LLM / agy execute
6. Bio catalog (optional): pair `axiom-science-os` without replacing Conductor ingress

## Front-specific install

See equal sections in `FRONT_ONBOARD.md` (HTTP, Cursor, Claude Code, Claude Science, Codex, ChatGPT). No front owns doctrine.
