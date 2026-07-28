# MystoraX Conductor — connector recipe (any front)

Same SSoT for every host UI (Cursor, Claude Code, Claude Science, Codex, ChatGPT, custom).

## A — MCP stdio (Cursor / Claude Code / Codex)

Pack `.mcp.json` → server **`mystorax-conductor`** (stdio → Conductor HTTP).  
`./install.sh` rewrites absolute server path and injects `MYSTORAX_HOST_TOKEN` from env or `~/.mystorax/secrets/host_ingress_token`.

| Tool | Purpose |
|------|---------|
| `mystorax_routing_guide` | Doctrine |
| `mystorax_surfaces` | Capability catalog |
| `mystorax_capability_lookup` | Filter |
| `mystorax_submit_goal` | Main ingress |
| `mystorax_job_status` | Poll |
| `mystorax_wait_stream_hint` | SSE wait |
| `mystorax_science_status` | Science readiness |
| `mystorax_science_resume` | Budgeted resume |
| `mystorax_axiom_tool_search` | Allowlisted bio search |
| `mystorax_axiom_tool_call` | Fail-closed bio call |

## B — HTTP (any custom connector / curl)

| Field | Value |
|-------|--------|
| Base | `https://mx.parallex.ca` |
| Auth | Bearer `MYSTORAX_HOST_TOKEN` |
| OpenAPI | `GET /v1/hosts/chatgpt/openapi.yaml` |
| MCP list | `GET /v1/hosts/mcp/tools` |
| MCP call | `POST /v1/hosts/mcp/tools/call` |
| Goal | `POST /v1/goal` |
| Manifest | `GET /v1/hosts/manifest` |

## C — Axiom bio (separate pack)

`https://axiom-mcp.parallex.ca/mcp` via **axiom-science-os**. Orthogonal to Conductor host ingress.

## Never

- Commit tokens into connector JSON
- Point connectors at Computer / ASI / local LLM endpoints
