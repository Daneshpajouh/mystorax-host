# ChatGPT Actions / OpenAPI connector

## Install (Custom GPT / Actions)

1. Create a Custom GPT or Actions-enabled GPT.
2. Import OpenAPI from either:
   - Live: `https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml`
   - Pack snapshot: `openapi/conductor.openapi.yaml` (refresh: `./scripts/refresh_openapi.sh`)
3. Authentication → API Key → Auth Type **Bearer** → value = `MYSTORAX_HOST_TOKEN`
4. First Actions each session: `getRoutingGuide` → `listSurfaces` → `submitGoal`

## Auth

| Header | Value |
|--------|--------|
| `Authorization` | `Bearer <host_ingress_token>` |

Never paste tokens into the OpenAPI file or this repo.

## Effort mapping (ChatGPT UI → Conductor)

| ChatGPT Intelligence | Conductor `effort` |
|----------------------|--------------------|
| Instant / Light | `low` |
| Standard / Medium | `medium` |
| Extended / High / Thinking | `high` |
| Heavy / Pro | `xhigh` |

## Doctrine (Actions)

- Prefer multi-step packages in **one** `submitGoal` (anti-fragment)
- Files → worker chatgpt or perplexity (never Gemini for files)
- Science: stop at EVIDENCE; never auto-CERTIFY
- Refuse Computer / ASI / agentic research / Spark / local LLM / agy

## Desktop

ChatGPT Desktop can use the same OpenAPI Actions when available; otherwise use any MCP/HTTP front with this pack installed.

## Smoke

Call `getHostManifest`, then `submitGoal` with text `Reply with exactly: MYSTORAX_OK`, `effort=low`, `job_class=research`.
