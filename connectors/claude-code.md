# Claude Code connector

## Install

```bash
git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
./install.sh --front claude
claude --plugin-dir ~/.claude/plugins/local/mystorax-host
# or from the clone:
claude --plugin-dir .
```

Installs:

- `~/.claude/plugins/local/mystorax-host`
- doctrine modules under `~/.claude/skills/mystorax-*`
- explicit `mystorax-conductor` MCP registration through the Claude CLI

## First tools / discovery

Prefer MCP tools when available; otherwise HTTP:

1. routing guide  
2. surfaces  
3. submit goal  

Load `mystorax-platform`, `mystorax-routing`, and the task module from `MODULE_INDEX.md`.

## Notes

- Equal peer to Cursor / Codex / Science — no Claude-only doctrine.
- Optional bio: import `axiom-science-os` separately; Conductor remains platform ingress.

## Smoke

```bash
./verify.sh
```

Fixes: `/mcp` missing → restart Claude Code; auth missing → install the issued token file; conflicting MCP → preserve it, remove/replace explicitly, then reinstall.
