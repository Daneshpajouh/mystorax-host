# ChatGPT Actions / OpenAPI connector

## Install (ChatGPT)

1. Create a Custom GPT or Actions-enabled GPT.
2. Import OpenAPI from either:
   - Live: `https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml`
   - Pack snapshot: `openapi/conductor.openapi.yaml` (refresh with `./scripts/refresh_openapi.sh`)
3. Authentication → API Key → Bearer token = `MYSTORAX_HOST_TOKEN`
4. First Actions in a session: `getRoutingGuide` → `listSurfaces` → `submitGoal`

## Auth

| Header | Value |
|--------|--------|
| `Authorization` | `Bearer <host_ingress_token>` |

Never paste tokens into the OpenAPI file or this repo.

## Doctrine (Actions)

- Prefer multi-step packages in one `submitGoal` (anti-fragment)
- Files → worker chatgpt or perplexity
- Science: stop at EVIDENCE; never auto-CERTIFY
- Refuse Computer / ASI / agentic research

## Desktop

ChatGPT Desktop can use the same OpenAPI Actions when available; otherwise use HTTP MCP via any front with this pack installed.
