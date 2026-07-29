# Codex connector

## Install

```bash
git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
./install.sh
```

Installs:

- pack `.codex-plugin/` into the host tree used by Codex plugin discovery when pointed at this dir
- doctrine modules → `~/.codex/skills/mystorax-*`
- MCP config via pack `.mcp.json` (and Cursor MCP merge if present on the machine)

Point Codex at the plugin directory or rely on synced skills + MCP server `mystorax-conductor`.

## First tools

1. `mystorax_routing_guide`  
2. `mystorax_surfaces`  
3. `mystorax_submit_goal`

## Notes

- Codex **CLI Hands** (thin apply) are separate from Codex-as-front.
- Conductor effort ≠ Codex `model_reasoning_effort` names — see routing guide `native_depth`.

## Smoke

```bash
./verify.sh
```
