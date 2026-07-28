# MystoraX Skills

Front-agnostic skills, MCP facade, and connector recipes for **MystoraX Conductor**.

**MystoraX** is the platform. Cursor, Claude Code, Claude Science, Codex, ChatGPT, Gemini-as-UI, and direct HTTP are **peer fronts** — equal, interchangeable, none owns doctrine.

Capability lives on Conductor HTTP: `https://mx.parallex.ca`. This pack teaches discovery + locked doctrine. It does not invent bridges or Hands authority.

Optional bio catalog: [`Daneshpajouh/axiom-science-os`](https://github.com/Daneshpajouh/axiom-science-os) — orthogonal; never replaces Conductor ingress.

## Discovery contract (every front)

1. `mystorax_routing_guide` — or `GET /v1/routing-guide`
2. `mystorax_surfaces` — or `GET /v1/surfaces`
3. Prefer `mystorax_submit_goal` — or `POST /v1/goal`
4. Long jobs: `mystorax_job_status` / wait-wake SSE — do not burn CLI tokens waiting

Cold bootstrap (no MCP): `GET https://mx.parallex.ca/v1/hosts/manifest`

## Install matrix

| Front | How |
|-------|-----|
| **HTTP / any agent** | Bearer `MYSTORAX_HOST_TOKEN` + endpoints above |
| **Cursor** | `./install.sh` → local plugin + `~/.cursor/mcp.json` |
| **Claude Code** | `./install.sh` → `~/.claude/skills` + MCP; or `claude --plugin-dir .` |
| **Claude Science** | Skills → Import from GitHub → `Daneshpajouh/mystorax-skills` (equal peer) |
| **Codex** | `./install.sh` → `~/.codex/skills` + MCP |
| **ChatGPT** | Import OpenAPI `https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml` |
| **Gemini as UI** | Text goals only via Conductor; files still need ChatGPT/Perplexity authors |
| **Custom MCP / OpenAPI** | See `connectors/mystorax-conductor.md` |

Equal-weight steps: [`FRONT_ONBOARD.md`](FRONT_ONBOARD.md). Agent contract: [`AGENTS.md`](AGENTS.md).

## Skills

| Skill | Purpose |
|-------|---------|
| `mystorax-platform` | Umbrella doctrine |
| `mystorax-routing` | Authors / Hands / effort / anti-fragment |
| `mystorax-submit-goal` | Main ingress |
| `mystorax-author-session` | One multi-step session; escalate before switch |
| `mystorax-bridges-authors` | ChatGPT / Perplexity / Gemini roles |
| `mystorax-perplexity-sources` | Source pin: web default; academic/github/hf/cf |
| `mystorax-hands-thin` | Apply/download/check only |
| `mystorax-hard-refuses` | Computer / ASI / local LLM / Spark / agy |
| `mystorax-science-os` | Campaigns; stop at EVIDENCE |
| `mystorax-wait-wake` | Durable long jobs |
| `mystorax-cost-human-gate` | Budget park + human gates |
| `mystorax-connectors-credentials` | Tokens + connectors (no secrets in git) |
| `mystorax-front-onboard` | Onboard **any** front |
| `mystorax-hosts-manifest` | Live manifest / Hands health |
| `mystorax-capability-surfaces` | Surfaces catalog |

## Doctrine (locked)

| Rule | Detail |
|------|--------|
| SSoT | Conductor HTTP |
| Files | Perplexity + ChatGPT only |
| Gemini | Text / long-context only |
| Hands | Thin `gemini → copilot → codex → cursor-agent → claude` |
| Science | Auto-stop at **EVIDENCE**; never auto-CERTIFY |
| Authors | Prefer one long session (50–200+ steps); escalate depth before provider switch |
| Perplexity sources | Default `web`; select `academic` / `github` / `huggingface` / `cloudflare` |
| Refuse | Computer / ASI / agentic_research / Spark / local LLMs / agy execute |
| Secrets | Never commit tokens |

## Quick install

```bash
export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
./install.sh
./verify.sh
```

Pack version: see [`VERSION`](VERSION).
