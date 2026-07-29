# Codex connector

## Install (this MacBook)

```bash
# Token once (if missing)
mkdir -p ~/.mystorax/secrets
# place issued host ingress token at:
#   ~/.mystorax/secrets/host_ingress_token
chmod 600 ~/.mystorax/secrets/host_ingress_token

export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"

# From GitHub (published pack) OR from the monorepo checkout:
git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
# monorepo alternative:
# cd /Users/studio/mystorax-platform/deploy/oci/hosts/mystorax-host

./install.sh --front codex
./install.sh --check
./verify.sh
```

Installs:

- `~/.codex/plugins/local/mystorax-host`
- doctrine modules → `~/.codex/skills/mystorax-*` (includes `mystorax-front-heavy-lift`)
- MCP `mystorax-conductor` via `codex mcp add` (preserves an existing registration)

Restart Codex, then confirm `codex mcp get mystorax-conductor`.

## First tools

1. `mystorax_routing_guide`
2. `mystorax_surfaces`
3. `mystorax_submit_goal` with `job_class=research|planning` for heavy lift

Load `mystorax-platform`, `mystorax-front-heavy-lift`, `mystorax-routing`, and the task module from `MODULE_INDEX.md`.

## Heavy lift (Codex as front + Hands)

- As a **front**: do not burn Codex usage on literature/brainstorm — submit Conductor goals to Perplexity/ChatGPT bridges.
- As a **thin Hand**: apply/download/check only after bridge artifacts. HEAVY design/research asks → `POST /v1/goal`, not CLI-context answers.
- Conductor `effort` ≠ Codex `model_reasoning_effort` names — see routing guide `native_depth`.

## Smoke

```bash
./verify.sh
```

Fixes: MCP absent → restart Codex and inspect `codex mcp get mystorax-conductor`; auth missing → install the issued token file; conflict → preserve/remove explicitly before reinstall.
