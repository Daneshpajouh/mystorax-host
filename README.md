# MystoraX Skills — front-agnostic

One pack for **every** MystoraX front: Cursor, Claude Code, Claude Science, Codex, ChatGPT Actions/Desktop, HTTP/curl, and any future MCP or OpenAPI host.

Capability lives on **Conductor HTTP** (`https://mx.parallex.ca`). Fronts are thin. This repo teaches discovery + doctrine; it does not invent bridges or Hands authority.

Pairs with [`Daneshpajouh/axiom-science-os`](https://github.com/Daneshpajouh/axiom-science-os) for bio catalog tools. That pack is optional and orthogonal.

## Discovery contract (all fronts)

1. `mystorax_routing_guide` — or `GET /v1/routing-guide`
2. `mystorax_surfaces` — or `GET /v1/surfaces`
3. Prefer `mystorax_submit_goal` — or `POST /v1/goal`
4. Long jobs: `mystorax_job_status` / wait-wake SSE — do not burn CLI tokens waiting

Bootstrap without MCP: `GET https://mx.parallex.ca/v1/hosts/manifest`

## Install matrix

| Front | How |
|-------|-----|
| **Any (HTTP)** | Bearer `MYSTORAX_HOST_TOKEN` + endpoints above |
| **Cursor** | `./install.sh` → plugin + `~/.cursor/mcp.json` |
| **Claude Code** | `./install.sh` → `~/.claude/skills` + MCP; or `claude --plugin-dir .` |
| **Claude Science** | Skills → Import from GitHub → `Daneshpajouh/mystorax-skills` (equal to other fronts) |
| **Codex** | `./install.sh` → `~/.codex/skills` + MCP |
| **ChatGPT** | Import OpenAPI `https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml` |

Full equal-weight steps: [`FRONT_ONBOARD.md`](FRONT_ONBOARD.md).

## Skills

| Skill | Purpose |
|-------|---------|
| `mystorax-platform` | Umbrella doctrine |
| `mystorax-routing` | Authors / Hands / effort |
| `mystorax-submit-goal` | Main ingress |
| `mystorax-science-os` | Campaigns; stop at EVIDENCE |
| `mystorax-bridges-authors` | ChatGPT / Perplexity / Gemini |
| `mystorax-hands-thin` | Apply/download/check only |
| `mystorax-hard-refuses` | Computer / ASI / local LLM / Spark |
| `mystorax-wait-wake` | Durable long jobs |
| `mystorax-cost-human-gate` | Budget park + human gates |
| `mystorax-connectors-credentials` | Tokens + connectors (no secrets in git) |
| `mystorax-front-onboard` | Onboard **any** front |
| `mystorax-hosts-manifest` | Live manifest / health |
| `mystorax-capability-surfaces` | Surfaces catalog usage |

## Doctrine (locked)

- HTTP SSoT = Conductor
- Files = Perplexity + ChatGPT only; Gemini text-only
- Hands = thin `gemini → copilot → codex → cursor-agent → claude`
- Science auto-resume stops at **EVIDENCE**; never auto-CERTIFY
- Refuse Computer / ASI / agentic_research / Spark / local LLMs / agy execute
- No secrets in this repo

## Quick install

```bash
export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
./install.sh
```
