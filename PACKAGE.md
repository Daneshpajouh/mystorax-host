# MystoraX host package — component matrix

Product: **mystorax-host** (not a skills-only repo).

| Path | Component | Fronts |
|------|-----------|--------|
| `.cursor-plugin/plugin.json` | Cursor plugin | Cursor |
| `.claude-plugin/plugin.json` | Claude plugin | Claude Code, Claude Science |
| `.claude-plugin/marketplace.json` | Claude marketplace | Claude Code |
| `.codex-plugin/plugin.json` | Codex plugin | Codex |
| `.mcp.json` | MCP wiring | Cursor, Claude, Codex |
| `rules/` | Always-on doctrine | Cursor |
| `commands/` | Slash commands | Cursor, Claude |
| `skills/` | Portable skill modules (one component) | Skill-capable fronts |
| `agents/` | Platform lead | Cursor, Claude, Codex |
| `scripts/conductor_mcp_server.py` | MCP server | MCP fronts |
| `python/mystorax_conductor_mcp/` | pip MCP connector | Any Python host |
| `openapi/conductor.openapi.yaml` | OpenAPI connector | ChatGPT Actions |
| `connectors/` | MCP + OpenAPI + HTTP recipes | All |
| `install.sh` / `uninstall.sh` / `verify.sh` | Lifecycle | Local installs |
| `AGENTS.md` / `FRONT_ONBOARD.md` | Contracts | All |

Canonical: `https://github.com/Daneshpajouh/mystorax-host`  
SSoT: `https://mx.parallex.ca`
