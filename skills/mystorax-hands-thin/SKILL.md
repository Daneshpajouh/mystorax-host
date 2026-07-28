---
name: mystorax-hands-thin
description: >
  MystoraX Hands are thin CLIs only — apply, download, check. Never use MCP, skills,
  plugins, or agy agents as Hands. Use after bridge-authored artifacts.
---

# MystoraX Hands (thin)

## Order

`gemini → copilot → codex → cursor-agent → claude`

Skip unavailable lanes (fail closed per lane). Live probe: `GET /v1/hosts/manifest` → `hands_health`.

## Allowed

- Apply authored patches / packages
- Download artifacts
- Light shell checks / verify markers

## Forbidden as Hands

- MCP tools / skills / plugins as apply plane
- `agy` agents / execute
- Silent bridge apply/shell
- Inventing local LLM “Hands”

## After failure

If no Hands remain: author-bridge completion or explicit terminal failure — bridges do not silently gain write authority.
