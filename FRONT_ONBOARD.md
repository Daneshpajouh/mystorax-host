# Front onboard — MystoraX (all hosts equal)

Same Conductor. Same token. Same discovery. Pick a front — doctrine does not change.

## Shared prerequisites

- `MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca`
- `MYSTORAX_HOST_TOKEN` = host ingress bearer (never commit)
- Axiom / bio MCP tokens stay on **Conductor only** (optional `MYSTORAX_AXIOM_MCP_TOKEN` server-side)

## Shared first calls

1. Routing guide → 2. Surfaces → 3. `submit_goal` / `POST /v1/goal`

Cold start: `GET $MYSTORAX_CONDUCTOR_URL/v1/hosts/manifest`

---

## HTTP / curl (any agent)

```bash
export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"

curl -fsS "$MYSTORAX_CONDUCTOR_URL/v1/hosts/manifest"
curl -fsS -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"name":"mystorax_routing_guide","arguments":{}}' \
  "$MYSTORAX_CONDUCTOR_URL/v1/hosts/mcp/tools/call"
curl -fsS -X POST "$MYSTORAX_CONDUCTOR_URL/v1/goal" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"text":"Reply with exactly: MYSTORAX_OK","job_class":"research","effort":"low","dispatch":true,"host":"custom","async_mode":true}'
```

---

## Cursor

```bash
./install.sh
./verify.sh
```

Enable MCP server **`mystorax-conductor`**. Skills land under `~/.cursor/plugins/local/mystorax-skills`.

---

## Claude Code

```bash
./install.sh
# or
claude plugin validate .
claude --plugin-dir .
```

Skills sync to `~/.claude/skills`. MCP via pack `.mcp.json` / install rewrite.

---

## Claude Science

Equal peer — not a special doctrine fork.

1. Skills → Import from GitHub → `Daneshpajouh/mystorax-skills`
2. Credentials → `MYSTORAX_HOST_TOKEN` (+ optional `MYSTORAX_CONDUCTOR_URL`)
3. Connectors → `connectors/mystorax-conductor.md` (MCP or HTTP)
4. Keep `axiom-science-os` only for optional bio catalog skills
5. Same discovery sequence as every other front

---

## Codex

```bash
./install.sh
```

Skills → `~/.codex/skills`. Register MCP `mystorax-conductor` the same way as Cursor.

---

## ChatGPT (Actions / Desktop)

1. Import OpenAPI: `https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml`
2. Auth: Bearer host ingress token
3. Call routing guide / list surfaces **before** submit goal
4. Prefer Actions → Conductor; do not scrape bridges
5. Multi-step packages: one goal, high/xhigh effort, ChatGPT or Perplexity worker

---

## Gemini as a *front* (UI only)

Gemini may be a text chat UI. Platform file packages still require ChatGPT or Perplexity authors via Conductor. Do not attach files to Gemini-routed goals.

---

## Custom MCP / OpenAPI host

Use `connectors/mystorax-conductor.md`. Point at Conductor HTTP or the stdio facade in `scripts/conductor_mcp_server.py`. Never invent bridge base URLs.

---

## Verify (all fronts)

Submit a tiny goal expecting `MYSTORAX_OK`, or run `./verify.sh`.

If tools missing: check token → `/health` → HTTP manifest fallback. Never invent bridge URLs. Never enable Computer / ASI.
