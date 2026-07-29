# Front readiness matrix — MystoraX host package 2.1.0

All fronts are **peers**. Transport differs; doctrine does not.

| Front | Install | Transport | Auth | First three calls | Smoke |
|-------|---------|-----------|------|-------------------|-------|
| Cursor | `./install.sh` | MCP + plugin | `MYSTORAX_HOST_TOKEN` in MCP env | routing_guide → surfaces → submit_goal | `./verify.sh` |
| Claude Code | `./install.sh` + `--plugin-dir` | MCP + plugin + skills dir | same | same | `./verify.sh` |
| Claude Science | GitHub import `Daneshpajouh/mystorax-host` | MCP and/or HTTP | same | same | manifest + submitGoal |
| Codex | `./install.sh` | MCP + plugin + skills dir | same | same | `./verify.sh` |
| ChatGPT Actions | Import OpenAPI URL | OpenAPI | Bearer token | getRoutingGuide → listSurfaces → submitGoal | Actions test call |
| Perplexity (UI front) | Space/instructions + companion HTTP | HTTP (companion) | Bearer via companion | manifest → routing → goal via companion | companion `./verify.sh` |
| Gemini (UI front) | Text goals via Conductor | HTTP / MCP companion | Bearer | same; **text-only** | low-effort text goal |
| Raw HTTP | curl / custom | HTTP | Bearer | manifest → routing → goal | `./verify.sh` |

## Locked doctrine (every row)

- SSoT: Conductor HTTP `https://mx.parallex.ca`
- Prefer `POST /v1/goal` over direct bridges/CLIs
- Files: ChatGPT or Perplexity only
- Gemini: text / long-context only
- Hands thin: `gemini → copilot → codex → cursor-agent → claude`
- Science auto-stop at **EVIDENCE**; never auto-CERTIFY
- HARD refuse: Computer / ASI / agentic_research / Spark / local LLM / agy
- Product name: **mystorax-host** (not skills)

## Live discovery

- Manifest: `GET /v1/hosts/manifest`
- OpenAPI: `GET /v1/hosts/chatgpt/openapi.yaml`
- Health: `GET /health` (includes `head_identity` when deployed)
