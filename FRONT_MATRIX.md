# Front readiness matrix — MystoraX host package 2.3.0

All fronts are **peers**. Transport differs; doctrine does not.

| Front | Install | Transport | Auth | First three calls | Smoke |
|-------|---------|-----------|------|-------------------|-------|
| Cursor | `./install.sh --front cursor` | native plugin + MCP | token-file reference | routing → surfaces → submit | `./verify.sh` |
| Claude Code | `./install.sh --front claude` | plugin + skills + native MCP registration | token-file reference | same | `./verify.sh` |
| Claude Science | GitHub import + companion | skills + companion MCP/HTTP | companion token-file | same | companion `./verify.sh` |
| Codex | `./install.sh --front codex` | plugin + skills + native MCP registration | token-file reference | same | `./verify.sh` |
| ChatGPT Desktop | Import when OpenAPI/Actions supported; otherwise companion | OpenAPI or companion | Bearer in vendor auth UI | getRoutingGuide → listSurfaces → submitGoal | Action/companion smoke |
| ChatGPT Actions | Import live OpenAPI URL | OpenAPI | Bearer in Action auth | same | Action test call |
| Perplexity UI | Space instructions + companion | companion HTTP/MCP | companion token-file | same | companion `./verify.sh` |
| Gemini UI | Text instructions + companion | companion HTTP, **text-only** | companion token-file | same | low-effort text goal |
| Raw HTTP | curl/custom client | HTTP | Bearer header at runtime | same | `./verify.sh` |

Native status is deliberately not overstated: Perplexity and Gemini UIs are companion paths, and ChatGPT Action import requires a vendor surface able to reach the public HTTPS Conductor.

## Locked doctrine (every row)

- SSoT: Conductor HTTP `https://mx.parallex.ca`
- Prefer `POST /v1/goal` over direct bridges/CLIs
- **Front token conservation:** research / search / brainstorm / synthesis → author bridges; fronts judge + ledger; Hands/CLI models submit HEAVY asks to bridges
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
