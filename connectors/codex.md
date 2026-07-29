# Codex connector

## Install

```bash
git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
./install.sh --front codex
```

Installs:

- pack `.codex-plugin/` into the host tree used by Codex plugin discovery when pointed at this dir
- doctrine modules → `~/.codex/skills/mystorax-*`
- explicit `mystorax-conductor` MCP registration through `codex mcp add`

Point Codex at the plugin directory or rely on synced skills + MCP server `mystorax-conductor`.

## First tools

1. `mystorax_routing_guide`  
2. `mystorax_surfaces`  
3. `mystorax_submit_goal`

Load `mystorax-platform`, `mystorax-routing`, and the task module from `MODULE_INDEX.md`.

## Notes

- Codex **CLI Hands** (thin apply) are separate from Codex-as-front.
- Conductor effort ≠ Codex `model_reasoning_effort` names — see routing guide `native_depth`.

## Smoke

```bash
./verify.sh
```

Fixes: MCP absent → restart Codex and inspect `codex mcp get mystorax-conductor`; auth missing → install the issued token file; conflict → preserve/remove explicitly before reinstall.
