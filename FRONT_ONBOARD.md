# Front onboard — MystoraX host package (all hosts equal)

Installable package: plugins + MCP + OpenAPI connector + doctrine modules.  
Same Conductor. Same token. Same discovery. Pick a front — doctrine does not change.

## Shared prerequisites

- `MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca`
- `MYSTORAX_HOST_TOKEN` = host ingress bearer (never commit)
- Axiom / bio MCP tokens stay on **Conductor only**

## Shared first calls

1. Routing guide → 2. Surfaces → 3. `submit_goal` / `POST /v1/goal`

Cold start: `GET $MYSTORAX_CONDUCTOR_URL/v1/hosts/manifest`

---

## Full local install (Cursor + Claude + Codex + MCP)

```bash
git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
./install.sh
./verify.sh
```

---

## HTTP / curl (any agent)

```bash
export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
curl -fsS "$MYSTORAX_CONDUCTOR_URL/v1/hosts/manifest"
curl -fsS -X POST "$MYSTORAX_CONDUCTOR_URL/v1/goal" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"text":"Reply with exactly: MYSTORAX_OK","job_class":"research","effort":"low","dispatch":true,"host":"custom","async_mode":true}'
```

---

## Cursor

`./install.sh` → `~/.cursor/plugins/local/mystorax-host` (+ gateway alias) + MCP.

Enable plugin / MCP **mystorax-conductor**.

---

## Claude Code

```bash
./install.sh
claude --plugin-dir ~/.claude/plugins/local/mystorax-host
# or from clone:
claude --plugin-dir .
```

---

## Claude Science

Equal peer — Import from GitHub → `Daneshpajouh/mystorax-host`.  
Credentials: `MYSTORAX_HOST_TOKEN`. Connectors: MCP or HTTP (`connectors/`).  
Optional bio: `axiom-science-os` (does not replace Conductor).

---

## Codex

`./install.sh` syncs skill modules + MCP the same as Cursor.

---

## ChatGPT (Actions / Desktop)

See `connectors/chatgpt-actions.md`.

1. Import OpenAPI: live URL or `openapi/conductor.openapi.yaml`
2. Bearer `MYSTORAX_HOST_TOKEN`
3. `getRoutingGuide` → `listSurfaces` → `submitGoal`

---

## Gemini as a *front* (UI only)

Text goals via Conductor. File packages still need ChatGPT or Perplexity authors.

---

## Custom MCP / OpenAPI host

`connectors/mystorax-conductor.md` + `pip install -e .` → `mystorax-conductor-mcp`.

---

## Uninstall / verify

```bash
./verify.sh
./uninstall.sh
```
