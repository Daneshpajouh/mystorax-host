# Front onboard — MystoraX (all hosts equal)

Same Conductor. Same token model. Same discovery sequence. Pick your front.

**Shared prerequisites**

- `MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca`
- `MYSTORAX_HOST_TOKEN` = host ingress bearer (never commit)
- Bio / Axiom MCP tokens stay on **Conductor only**

**Shared first calls**

1. routing guide → 2. surfaces → 3. `submit_goal` / `POST /v1/goal`

---

## HTTP / curl (any agent)

```bash
curl -fsS "$MYSTORAX_CONDUCTOR_URL/v1/hosts/manifest"
curl -fsS -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"name":"mystorax_routing_guide","arguments":{}}' \
  "$MYSTORAX_CONDUCTOR_URL/v1/hosts/mcp/tools/call"
curl -fsS -X POST "$MYSTORAX_CONDUCTOR_URL/v1/goal" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"text":"Reply MYSTORAX_OK","job_class":"research","effort":"low","dispatch":true,"host":"custom"}'
```

---

## Cursor

```bash
./install.sh
```

Enable MCP server `mystorax-conductor`. Skills land under the local plugin + user MCP merge.

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

Equal citizen — not a special doctrine fork.

1. Skills → Import from GitHub → `Daneshpajouh/mystorax-skills`
2. Credentials → `MYSTORAX_HOST_TOKEN` (+ optional `MYSTORAX_CONDUCTOR_URL`)
3. Connectors → see `connectors/mystorax-conductor.md` (MCP or HTTP)
4. Keep `axiom-science-os` imported only for bio catalog skills
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

---

## Gemini as a *front*

Gemini may be used as a text UI. Platform file packages still require ChatGPT or Perplexity authors via Conductor. Do not attach files to Gemini-routed goals.

---

## Verify (all fronts)

Submit a tiny goal expecting `MYSTORAX_OK`. If tools missing: check token, `/health`, then HTTP manifest fallback. Never invent bridge URLs.
