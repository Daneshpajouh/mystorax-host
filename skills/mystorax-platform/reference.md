# MystoraX platform reference (live endpoints)

Base: `https://mx.parallex.ca`

| Purpose | Method | Path |
|---------|--------|------|
| Health | GET | `/health` |
| Hosts manifest | GET | `/v1/hosts/manifest` |
| Routing guide | GET | `/v1/routing-guide` |
| Surfaces | GET | `/v1/surfaces` |
| Submit goal | POST | `/v1/goal` |
| Job status | GET | `/v1/jobs/{job_id}/status` |
| Wait SSE | GET | `/v1/waits/{wait_id}/stream` |
| MCP tools | GET | `/v1/hosts/mcp/tools` |
| MCP call | POST | `/v1/hosts/mcp/tools/call` |
| ChatGPT OpenAPI | GET | `/v1/hosts/chatgpt/openapi.yaml` |
| Axiom status | GET | `/v1/axiom/status` |

Auth on writes: `Authorization: Bearer $MYSTORAX_HOST_TOKEN`.

Doctrine version (manifest): `mystorax.front_agnostic.v1`.

Re-fetch routing guide when unsure — do not rely on this file alone.
