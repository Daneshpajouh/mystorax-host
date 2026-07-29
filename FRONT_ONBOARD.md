# Front onboard — MystoraX host package (all peers equal)

Installable package: plugins + MCP + OpenAPI + HTTP connectors + doctrine modules.  
Same Conductor. Same token. Same discovery. Pick a front — **doctrine does not change**.

Conductor SSoT: `https://mx.parallex.ca`  
Product: **`mystorax-host`** (never “skills”)  
Version: see `VERSION` (`2.3.0`)

## Shared prerequisites

| Item | Value |
|------|--------|
| URL | `MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca` |
| Auth | Bearer `MYSTORAX_HOST_TOKEN` (file: `~/.mystorax/secrets/host_ingress_token`) |
| Axiom / bio tokens | Stay on **Conductor only** — fronts do not need them for normal goals |

## Shared first calls (every front)

1. Routing guide → 2. Surfaces → 3. Submit goal (`job_class=research|planning` for heavy lift)  
Cold bootstrap: `GET $MYSTORAX_CONDUCTOR_URL/v1/hosts/manifest`

Front token conservation: load `mystorax-front-heavy-lift`. Offload research/brainstorm to bridges.

---

## Full local install (MacBook: Cursor + Claude Code + Codex + MCP)

```bash
# 1) Token (once)
mkdir -p ~/.mystorax/secrets
# put the issued host ingress token in:
#   ~/.mystorax/secrets/host_ingress_token
chmod 600 ~/.mystorax/secrets/host_ingress_token

# 2) Pack
git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
# OR monorepo path on this machine:
# cd /Users/studio/mystorax-platform/deploy/oci/hosts/mystorax-host

export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"

./install.sh --front all
./install.sh --check
./verify.sh
```

Then enable/reload each front (installer prints the checklist).

Per-front recipes: `connectors/`. Matrix: `PACKAGE.md`. Readiness: `FRONT_MATRIX.md`.

---

## Cursor

See `connectors/cursor.md`.

`./install.sh --front cursor` → `~/.cursor/plugins/local/mystorax-host` + MCP `mystorax-conductor`.  
Enable the plugin and MCP. First tools: `mystorax_routing_guide` → `mystorax_surfaces` → `mystorax_submit_goal`.

---

## Claude Code

See `connectors/claude-code.md`.

```bash
./install.sh --front claude
claude --plugin-dir ~/.claude/plugins/local/mystorax-host
```

Doctrine modules also sync to `~/.claude/skills/mystorax-*`.

---

## Claude Science

See `connectors/claude-science.md`.

Equal peer — Import from GitHub → `Daneshpajouh/mystorax-host`.  
Credentials: `MYSTORAX_HOST_TOKEN`. Use MCP and/or HTTP.  
Optional bio pack: `axiom-science-os` (does **not** replace Conductor).

---

## Codex

See `connectors/codex.md`.

`./install.sh --front codex` syncs `.codex-plugin`, doctrine modules under `~/.codex/skills/mystorax-*`, and MCP the same as Cursor when Codex reads the pack MCP config.

---

## ChatGPT (Actions / Desktop)

See `connectors/chatgpt-actions.md`.

1. Import OpenAPI: `https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml`  
2. Bearer `MYSTORAX_HOST_TOKEN`  
3. `getRoutingGuide` → `listSurfaces` → `submitGoal`

---

## Perplexity (as a *front*)

See `connectors/perplexity-front.md`.

Perplexity is also a **bridge author** inside Conductor. As a human front:

- Put Conductor doctrine + HTTP recipe in a Space / custom instructions.
- Prefer submitting goals through Companion MCP/HTTP (Cursor/Claude/Codex/curl) while using Perplexity UI for reading/research.
- Never ask Perplexity Computer / ASI / agentic research — HARD refused.

---

## Gemini (as a *front* / UI)

See `connectors/gemini-front.md`.

Text / long-context goals via Conductor only. **No file packages** from Gemini.  
File authorship stays on ChatGPT or Perplexity bridges.

---

## HTTP / curl (any agent)

See `connectors/http.md`.

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

## Custom MCP host

`connectors/mystorax-conductor.md` + `pip install -e .` → `mystorax-conductor-mcp`.

---

## Uninstall / verify

```bash
./verify.sh
./uninstall.sh
```
