# Claude Code connector

## Install

```bash
git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
./install.sh
claude --plugin-dir ~/.claude/plugins/local/mystorax-host
# or from the clone:
claude --plugin-dir .
```

Installs:

- `~/.claude/plugins/local/mystorax-host`
- doctrine modules under `~/.claude/skills/mystorax-*`
- pack `.mcp.json` for MCP stdio

## First tools / discovery

Prefer MCP tools when available; otherwise HTTP:

1. routing guide  
2. surfaces  
3. submit goal  

## Notes

- Equal peer to Cursor / Codex / Science — no Claude-only doctrine.
- Optional bio: import `axiom-science-os` separately; Conductor remains platform ingress.

## Smoke

```bash
./verify.sh
```
