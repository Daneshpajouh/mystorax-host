# Claude Science connector

Claude Science is an **equal peer front** — not the owner of MystoraX doctrine.

## Install

1. Import from GitHub: `Daneshpajouh/mystorax-host`
2. Set env **`MYSTORAX_HOST_TOKEN`** (not `MYSTORAX`) to the host ingress token. Optional: `MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca`.
3. Prefer direct HTTPS to Conductor from the Science sandbox:
   - Base: `https://mx.parallex.ca`
   - Auth: `Authorization: Bearer $MYSTORAX_HOST_TOKEN`
4. If Settings → Connectors offers a custom remote MCP for MystoraX, attach it; otherwise use HTTP (tools below). Stdio MCP from the pack is for local Claude Code/Cursor companions, not the Science sandbox.

Optional orthogonal bio pack: `Daneshpajouh/axiom-science-os`  
Axiom tokens stay on Conductor; Science auto-resume stops at **EVIDENCE**.

## First calls

1. `GET /health` (prove sandbox reachability)
2. `GET /v1/routing-guide` or MCP `mystorax_routing_guide`
3. `GET /v1/surfaces` or MCP `mystorax_surfaces`
4. `POST /v1/goal` or MCP `mystorax_submit_goal` — **default path for research/brainstorm/search**

Load `mystorax-platform`, `mystorax-front-heavy-lift`, `mystorax-science-os`, and the task module from `MODULE_INDEX.md`.

## Heavy lift (preserve Science usage limits)

Claude Science **must offload** literature, prior-art, search, brainstorming,
estimand redesign debates, and long synthesis to MystoraX author bridges via
Conductor. Do not burn Science session tokens redoing work bridges already host.

| Keep on Science (cheap) | Send to bridges via `POST /v1/goal` |
|-------------------------|-------------------------------------|
| Frame the next falsifier / claim | Literature / web / academic search |
| Ledger claims, barriers, dissents, prereg | Brainstorm rival estimands / designs |
| Read artifacts; decide next measurement | Multi-source synthesis packages |
| Thin Hands apply/download/check | Deep multi-step authoring sessions |

Pattern:

```bash
curl -fsS -X POST "$MYSTORAX_CONDUCTOR_URL/v1/goal" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "text":"<one multi-step research/brainstorm goal with success criteria>",
    "job_class":"research",
    "effort":"high",
    "host":"claude_science",
    "dispatch":true,
    "async_mode":true,
    "bridge_opts":{"mode":"research","sources":["academic","web"]}
  }'
```

Use `job_class=research` or `planning` for heavy lift. **Do not** use
`job_class=science` for literature/brainstorm — that opens a Science OS campaign
and returns checkpoints, not bridge prose. After accept, wait/wake on `job_id`
and read `result.result` / bridge payload for the answer text.

Hands/CLI models facing HEAVY asks also submit Conductor goals to bridges.

## Sandbox networking

Claude Science sandbox requests often use Anthropic/`Claude-User` user-agents. Cloudflare **AI Bots protection** on `parallex.ca` must **not** block those UAs for `mx.parallex.ca` / `axiom-mcp.parallex.ca`, or the sandbox proxy returns **403**. Ops: zone Bot Management → `ai_bots_protection=disabled` (or WAF skip for Claude/Anthropic UAs on API hosts). Do **not** route via nibi/HPC unless direct HTTPS fails.

## Doctrine reminders

- Prefer Conductor over calling bridges or CLIs directly
- Offload research/search/brainstorm to bridges; Science judges + ledgers
- Files → ChatGPT or Perplexity authors only
- Never auto-CERTIFY Science campaigns
- HARD refuse Computer / ASI / agentic_research / Spark / local LLM / agy

Smoke: `curl -fsS -A Claude-User https://mx.parallex.ca/health` must be 200; then routing → surfaces → goal. Fixes: 403 from sandbox → Cloudflare AI-bot block; missing bio tools → pair optional Axiom pack; wrong env name → use `MYSTORAX_HOST_TOKEN`.
