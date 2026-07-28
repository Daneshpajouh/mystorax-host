---
name: mystorax-hands-thin
description: >
  MystoraX thin Hands CLIs — gemini, copilot, codex, cursor-agent, claude apply/download/check only.
  Use after bridges author artifacts; never treat Hands as planners or agentic shells.
---

# MystoraX Hands (thin)

## Order

`gemini → copilot → codex → cursor-agent → claude`

## Allowed

apply_patch, download_artifact, verify_tests, git_status/diff, smoke_check, read_file

## Not Hands

MCP skills, plugins, agy agents, Computer, arbitrary shell, secret exfil.

## Health

`GET /v1/hosts/manifest` → `hands_health`. Missing CLIs are skipped (fail closed per lane).
