# MystoraX Conductor Connector

MystoraX supports raw HTTP, local stdio MCP, and OpenAPI as equal connection methods. All three terminate at Conductor HTTP.

## Environment

```bash
export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN='set-through-a-secret-store'
```

Never store the token in this repository or in `.mcp.json`.

## Endpoints

| Purpose | Method and path | Auth |
|---|---|---|
| Health | `GET /health` | No |
| Host bootstrap | `GET /v1/hosts/manifest` | No |
| Routing doctrine | `GET /v1/routing-guide` | No |
| Capability surfaces | `GET /v1/surfaces` | No |
| MCP descriptors | `GET /v1/hosts/mcp/tools` | No |
| MCP HTTP call | `POST /v1/hosts/mcp/tools/call` | Bearer |
| Submit goal | `POST /v1/goal` | Bearer |
| Job status | `GET /v1/jobs/{job_id}/status` | Bearer |
| Wait stream | `GET /v1/waits/{wait_id}/stream` | Bearer |
| Science status | `GET /v1/axiom/status` | No |
| Science resume | `POST /v1/axiom/campaigns/{campaign_id}/resume` | Bearer |
| Axiom tool call | `POST /v1/axiom/mcp/tools/call` | Bearer |
| ChatGPT OpenAPI | `GET /v1/hosts/chatgpt/openapi.yaml` | No |

## Raw HTTP

### Bootstrap and discovery

```bash
BASE="${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}"

curl -fsS "$BASE/v1/hosts/manifest"
curl -fsS "$BASE/v1/routing-guide"
curl -fsS "$BASE/v1/surfaces"
```

### Submit a goal

```bash
curl -fsS -X POST "$BASE/v1/goal" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Produce a complete, verified result.",
    "host": "raw_http",
    "job_class": "coding",
    "effort": "high",
    "dispatch": true,
    "async_mode": true
  }'
```

Supported request fields are `text`, `host`, `voice`, `job_class`, `effort`, `worker`, `model`, `mode`, `bridge_opts`, `metadata`, `dispatch`, and `async_mode`.

### Perplexity source selection

```bash
curl -fsS -X POST "$BASE/v1/goal" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Research the topic using academic and repository evidence.",
    "host": "raw_http",
    "job_class": "research",
    "bridge_opts": {
      "sources": ["academic", "github"]
    },
    "dispatch": true
  }'
```

Omit `sources` for web-only research. Accepted selectors are `web`, `academic`, `github`, `huggingface` or `hf`, `cloudflare` or `cf`, and opt-in `notion`.

### Poll job status

```bash
curl -fsS \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  "$BASE/v1/jobs/$JOB_ID/status"
```

### Wait with SSE

```bash
curl -N \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  "$BASE/v1/waits/$WAIT_ID/stream"
```

### Resume Science OS

```bash
curl -fsS -X POST "$BASE/v1/axiom/campaigns/$CAMPAIGN_ID/resume" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "goal": "Continue the campaign through evidence collection.",
    "max_phases": 1,
    "max_auto_phase": "EVIDENCE",
    "via": "cookie"
  }'
```

Never set automatic progression beyond `EVIDENCE`. Never auto-CERTIFY.

## Local stdio MCP

Repository config:

```json
{
  "mcpServers": {
    "mystorax-conductor": {
      "command": "python3",
      "args": ["scripts/conductor_mcp_server.py"],
      "env": {
        "MYSTORAX_CONDUCTOR_URL": "https://mx.parallex.ca"
      }
    }
  }
}
```

For global front configuration, replace the server path with an absolute path. Supply `MYSTORAX_HOST_TOKEN` through the front's credential UI or inherited environment.

The server uses no third-party Python packages.

## HTTP MCP twin

List live descriptors:

```bash
curl -fsS "$BASE/v1/hosts/mcp/tools"
```

Call a tool:

```bash
curl -fsS -X POST "$BASE/v1/hosts/mcp/tools/call" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "mystorax_submit_goal",
    "arguments": {
      "text": "Produce the requested result.",
      "job_class": "research",
      "dispatch": true
    }
  }'
```

## OpenAPI

Use either:

- live: `https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml`
- repository: `openapi/conductor.openapi.yaml`

Configure Bearer authentication in the front's credential UI. Keep discovery operations unauthenticated and goal operations authenticated.

## Error handling

- `400`: fix the request; do not guess missing required fields.
- `401` or `403`: fix credential delivery; do not place the token in source.
- `402`: cost ceiling reached; preserve the parked state.
- `409`: preserve conflict or gate details; do not force a duplicate action.
- `422`: respect validation or Science OS phase restrictions.
- `429`: back off and preserve the durable ID.
- `5xx`: use durable status, recovery, or escalation before switching authors.

## Discovery invariant

Every connector must expose the sequence:

`routing_guide -> surfaces -> submit_goal`

The host manifest is the bootstrap for that sequence.
