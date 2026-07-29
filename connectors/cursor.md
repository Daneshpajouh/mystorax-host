# Cursor connector

## Install

```bash
git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
./install.sh
```

Installs:

- `~/.cursor/plugins/local/mystorax-host`
- alias `~/.cursor/plugins/local/mystorax-gateway`
- MCP server `mystorax-conductor` in `~/.cursor/mcp.json`

Enable the plugin under Cursor Settings → Plugins / MCP.

## First tools

1. `mystorax_routing_guide`
2. `mystorax_surfaces`
3. `mystorax_submit_goal`

## Rules

Always-on doctrine: `rules/mystorax-doctrine.mdc`  
Agent contract: `AGENTS.md`

## Smoke

```bash
./verify.sh
```
