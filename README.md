# MystoraX Host Package

Version `2.0.1`. This repository was formerly named `mystorax-skills`.

MystoraX is a front-agnostic goal platform. Every supported front is a thin peer over the same Conductor HTTP contract.

**Capability source of truth:** `https://mx.parallex.ca`

No editor, chat client, CLI, plugin, or model owns routing doctrine. Conductor owns routing, capability discovery, admission, durable state, cost controls, human gates, and goal dispatch.

## Architecture

```text
HTTP/curl | Cursor | Claude Code | Claude Science | Codex
ChatGPT Actions/Desktop | Gemini-as-UI | custom MCP/OpenAPI hosts
                              |
                              v
                 MystoraX Conductor HTTP SSoT
                    https://mx.parallex.ca
                              |
             Authors create complete work packages
                 Hands apply, download, and check
```

The local MCP server in this repository is a thin HTTP facade. It does not become a second orchestrator.

## Peer fronts

| Front | Connection | Local role |
|---|---|---|
| HTTP or `curl` | Raw Conductor HTTP | Direct, scriptable peer |
| Cursor | Skills plus stdio MCP | Thin coding and operator front |
| Claude Code | Skills plus stdio MCP | Thin coding and operator front |
| Claude Science | Skills plus MCP or HTTP | Thin scientific-work front |
| Codex | Skills plus stdio MCP | Thin coding and operator front |
| ChatGPT Actions/Desktop | OpenAPI or MCP | Thin conversational front |
| Gemini-as-UI | HTTP or MCP through its host | Text-only front |
| Custom host | MCP, OpenAPI, or raw HTTP | Equal peer using the same discovery contract |

## Install matrix

| Front | Install path |
|---|---|
| Any shell or service | Read `connectors/mystorax-conductor.md` |
| Cursor | Run `./install.sh --cursor`, or use `.cursor-plugin/plugin.json` |
| Claude Code | Run `./install.sh --claude`, or copy `skills/*` into the front's skills directory |
| Claude Science | Use the same skills and MCP config as Claude Code |
| Codex | Run `./install.sh --codex`, or use `.codex-plugin/plugin.json` |
| ChatGPT Actions | Import `https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml` or `openapi/conductor.openapi.yaml` |
| ChatGPT Desktop | Register `.mcp.json`, or use the OpenAPI contract |
| Gemini-as-UI | Configure its host to call HTTP or the MCP server; keep Gemini text-only |
| Custom MCP/OpenAPI host | Use `.mcp.json` or `openapi/conductor.openapi.yaml` |

`install.sh` never stores credentials. Export credentials in the process environment or use the front's credential UI.

## Doctrine

| Topic | Contract |
|---|---|
| Capability SSoT | Conductor HTTP at `https://mx.parallex.ca` |
| Discovery | `routing_guide` then `surfaces` then `submit_goal` |
| Bootstrap | `GET /v1/hosts/manifest` |
| Authoring | Bridges author complete outputs and work packages |
| Files | Perplexity and ChatGPT only |
| Gemini | Text and long-context work only, never file packages |
| Hands | `gemini -> copilot -> codex -> cursor-agent -> claude` |
| Hands scope | Apply, download, and check only |
| Science OS | Auto-resume may advance only through `EVIDENCE` |
| Certification | Never auto-CERTIFY |
| Cost | Respect Conductor cost ceilings and parked goals |
| Irreversible work | Require an approved human gate |
| Secrets | Environment variables or front credential UI only |
| Hard refuses | Computer, ASI, `agentic_research`, Tasks credits, Spark, local LLM, `agy execute` |

## Discovery contract

Every front follows the same sequence.

### 1. Bootstrap

```bash
curl -fsS "${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}/v1/hosts/manifest"
```

### 2. Read routing doctrine

```bash
curl -fsS "${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}/v1/routing-guide"
```

### 3. Inspect capability surfaces

```bash
curl -fsS "${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}/v1/surfaces"
```

Statuses may include `wired`, `guided`, `inventory`, `refused`, and `deferred`. Do not invent a route for a missing or refused surface.

### 4. Submit the goal

```bash
curl -fsS -X POST \
  "${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}/v1/goal" \
  -H "Authorization: Bearer ${MYSTORAX_HOST_TOKEN:?set MYSTORAX_HOST_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Produce the requested result and return complete evidence.",
    "host": "http_curl",
    "job_class": "research",
    "effort": "medium",
    "dispatch": true
  }'
```

Supported goal fields include `text`, `host`, `voice`, `job_class`, `effort`, `worker`, `model`, `mode`, `bridge_opts`, `metadata`, `dispatch`, and `async_mode`.

## Perplexity sources

Perplexity defaults to web-only research when no source list is supplied.

Opt in through `bridge_opts.sources` or `metadata.sources`:

```json
{
  "text": "Review the evidence and cite primary sources.",
  "job_class": "research",
  "bridge_opts": {
    "sources": ["academic", "github"]
  }
}
```

Accepted source names:

- `web`
- `academic`
- `github`
- `huggingface` or `hf`
- `cloudflare` or `cf`
- `notion`, opt-in only

Do not add unsupported source names. Do not enable Notion unless the goal requires it.

## MCP tools

The included server exposes the Conductor's 10-tool facade:

- `mystorax_routing_guide`
- `mystorax_surfaces`
- `mystorax_capability_lookup`
- `mystorax_submit_goal`
- `mystorax_job_status`
- `mystorax_wait_stream_hint`
- `mystorax_science_status`
- `mystorax_science_resume`
- `mystorax_axiom_tool_search`
- `mystorax_axiom_tool_call`

The server prefers live tool descriptors from `GET /v1/hosts/mcp/tools`. It falls back to the bundled descriptors only when discovery is unavailable.

## Verify

```bash
export MYSTORAX_HOST_TOKEN='set-through-a-secret-store'
./verify.sh
```

For static checks without a credential:

```bash
./verify.sh --offline
```

The live verification submits `Reply with exactly: MYSTORAX_OK` through `POST /v1/goal` and follows durable job status when required.

## Repository layout

```text
AGENTS.md
FRONT_ONBOARD.md
README.md
agents/
connectors/
openapi/
scripts/
skills/
.cursor-plugin/
.claude-plugin/
.codex-plugin/
.mcp.json
install.sh
verify.sh
credentials.example.env
VERSION
```

## Safety boundary

This pack does not expose direct bridge URLs, embed credentials, create a local orchestrator, or authorize refused surfaces. When Conductor and a front disagree, Conductor wins.
