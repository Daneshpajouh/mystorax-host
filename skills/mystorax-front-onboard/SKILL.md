---
name: mystorax-front-onboard
description: >
  Onboard any MystoraX front (Cursor, Claude Code, Claude Science, Codex, ChatGPT,
  Gemini-as-UI, HTTP, custom MCP). Equal steps for every front — never Claude-Science-only.
---

# MystoraX Front Onboard

Read `FRONT_ONBOARD.md` and `AGENTS.md` in this pack. All fronts share one Conductor.

## Checklist (every front)

1. Set `MYSTORAX_CONDUCTOR_URL` + `MYSTORAX_HOST_TOKEN`
2. Discover: routing guide → surfaces → manifest
3. Prefer `mystorax_submit_goal` / `POST /v1/goal`
4. Keep multi-step work in one author session
5. Science: stop at EVIDENCE; never auto-CERTIFY
6. Refuse Computer / ASI / Spark / local LLM / agy execute
7. Bio catalog (optional): pair `axiom-science-os` without replacing Conductor ingress
8. Verify with `MYSTORAX_OK` or `./verify.sh`

## Front-specific install

Equal sections in `FRONT_ONBOARD.md`. No front owns doctrine.

Start with `mystorax_hosts_manifest` / `GET /v1/hosts/manifest`, then routing, surfaces, and submit. Use the card in `connectors/` matching the current front and verify with `./verify.sh`.
