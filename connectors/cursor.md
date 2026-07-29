# Cursor connector

## Install

```bash
git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
./install.sh --front cursor
```

Installs:

- `~/.cursor/plugins/local/mystorax-host`
- MCP server `mystorax-conductor` in `~/.cursor/mcp.json`

Enable the plugin under Cursor Settings → Plugins / MCP.

## First tools

1. `mystorax_routing_guide`
2. `mystorax_surfaces`
3. `mystorax_submit_goal`

## Rules

Always-on doctrine: `rules/mystorax-doctrine.mdc`  
Agent contract: `AGENTS.md`

Load `mystorax-platform`, `mystorax-routing`, and the task module from `MODULE_INDEX.md`.

## Smoke

```bash
./verify.sh
```

Fixes: token missing → place the issued token at `~/.mystorax/secrets/host_ingress_token`; MCP missing → enable it in Settings and reload; conflict → preserve the existing entry, remove/replace it explicitly, then reinstall.
