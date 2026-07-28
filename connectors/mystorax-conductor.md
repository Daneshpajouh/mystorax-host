# MystoraX Conductor — connector recipe (any front)

Same SSoT for every host UI. Pick a transport — doctrine does not change.

## A — MCP stdio (Cursor / Claude Code / Codex / local agents)

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

HTTP equivalents (same names):

```bash
GET  $MYSTORAX_CONDUCTOR_URL/v1/hosts/mcp/tools
POST $MYSTORAX_CONDUCTOR_URL/v1/hosts/mcp/tools/call
# body: {"name":"mystorax_routing_guide","arguments":{}}
```

## B — OpenAPI (ChatGPT Actions / compatible clients)

| Field | Value |
|-------|--------|
| Spec | `https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml` |
| Auth | Bearer `MYSTORAX_HOST_TOKEN` |
| First calls | routing guide → surfaces → submit goal |

## C — Raw HTTP (curl / custom)

| Field | Value |
|-------|--------|
| Base | `https://mx.parallex.ca` |
| Auth | Bearer `MYSTORAX_HOST_TOKEN` |
| Goal | `POST /v1/goal` |
| Manifest | `GET /v1/hosts/manifest` |
| Routing | `GET /v1/routing-guide` |
| Surfaces | `GET /v1/surfaces` |
| Job status | `GET /v1/jobs/{job_id}/status` |
| Wait SSE | `GET /v1/waits/{wait_id}/stream` |

## D — Axiom bio (separate pack)

`https://axiom-mcp.parallex.ca/mcp` via **axiom-science-os**. Orthogonal to Conductor host ingress.

## Never

- Commit tokens into connector JSON
- Point connectors at Computer / ASI / local LLM endpoints
- Treat any single front as the platform
