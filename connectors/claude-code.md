# Claude Code connector

## Install (this MacBook)

```bash
mkdir -p ~/.mystorax/secrets
chmod 600 ~/.mystorax/secrets/host_ingress_token

export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"

git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
# monorepo alternative:
# cd /Users/studio/mystorax-platform/deploy/oci/hosts/mystorax-host

./install.sh --front claude
./install.sh --check
./verify.sh

claude --plugin-dir ~/.claude/plugins/local/mystorax-host
# or from the clone:
# claude --plugin-dir .
```

Installs:

- `~/.claude/plugins/local/mystorax-host`
- doctrine modules under `~/.claude/skills/mystorax-*` (includes `mystorax-front-heavy-lift`)
- MCP `mystorax-conductor` via Claude CLI (preserves an existing registration)

Restart Claude Code, run `/mcp`, confirm `mystorax-conductor`.

## First tools / discovery

Prefer MCP tools when available; otherwise HTTP:

1. routing guide
2. surfaces
3. submit goal (`job_class=research|planning` for heavy lift)

Load `mystorax-platform`, `mystorax-front-heavy-lift`, `mystorax-routing`, and the task module from `MODULE_INDEX.md`.

## Notes

- Equal peer to Cursor / Codex / Science — no Claude-only doctrine.
- Conserve Claude usage: offload research/brainstorm to MystoraX bridges.
- Optional bio: import `axiom-science-os` separately; Conductor remains platform ingress.

## Smoke

```bash
./verify.sh
```

Fixes: `/mcp` missing → restart Claude Code; auth missing → install the issued token file; conflicting MCP → preserve it, remove/replace explicitly, then reinstall.
