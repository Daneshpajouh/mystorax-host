# Cursor connector

## Install (this MacBook)

```bash
mkdir -p ~/.mystorax/secrets
# ensure issued token exists at ~/.mystorax/secrets/host_ingress_token
chmod 600 ~/.mystorax/secrets/host_ingress_token

export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"

git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
# monorepo alternative:
# cd /Users/studio/mystorax-platform/deploy/oci/hosts/mystorax-host

./install.sh --front cursor
./install.sh --check
./verify.sh
```

Installs:

- `~/.cursor/plugins/local/mystorax-host`
- MCP server `mystorax-conductor` in `~/.cursor/mcp.json`

Enable under Cursor Settings → Plugins / MCP, then reload.

## First tools

1. `mystorax_routing_guide`
2. `mystorax_surfaces`
3. `mystorax_submit_goal` (`job_class=research|planning` for heavy lift)

## Rules

Always-on doctrine: `rules/mystorax-doctrine.mdc` (includes front token conservation)  
Agent contract: `AGENTS.md`

Load `mystorax-platform`, `mystorax-front-heavy-lift`, `mystorax-routing`, and the task module from `MODULE_INDEX.md`.

## Smoke

```bash
./verify.sh
```

Fixes: token missing → place the issued token at `~/.mystorax/secrets/host_ingress_token`; MCP missing → enable it in Settings and reload; conflict → preserve the existing entry, remove/replace it explicitly, then reinstall.
