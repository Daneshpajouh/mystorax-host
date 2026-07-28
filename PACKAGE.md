# MystoraX host package — component matrix

| Path | Component | Fronts |
|------|-----------|--------|
| `.cursor-plugin/plugin.json` | Cursor plugin manifest | Cursor |
| `.claude-plugin/plugin.json` | Claude plugin manifest | Claude Code, Claude Science |
| `.claude-plugin/marketplace.json` | Claude marketplace entry | Claude Code |
| `.codex-plugin/plugin.json` | Codex plugin manifest | Codex |
| `.mcp.json` | MCP stdio wiring | Cursor, Claude, Codex |
| `rules/mystorax-doctrine.mdc` | Always-on doctrine rule | Cursor |
| `commands/*.md` | Slash commands | Cursor, Claude |
| `skills/*/SKILL.md` | Portable skills | All skill-capable fronts |
| `agents/mystorax-platform-lead.md` | Lead agent | Cursor, Claude, Codex |
| `scripts/conductor_mcp_server.py` | MCP server (stdio) | All MCP fronts |
| `python/mystorax_conductor_mcp/` | pip package | Any Python host |
| `pyproject.toml` | `mystorax-conductor-mcp` | pip / uv |
| `openapi/conductor.openapi.yaml` | OpenAPI snapshot | ChatGPT Actions |
| `connectors/chatgpt-actions.md` | Actions install guide | ChatGPT |
| `connectors/mystorax-conductor.md` | MCP + HTTP recipes | All |
| `install.sh` | Full installer | Local Mac/Linux |
| `uninstall.sh` | Remover | Local |
| `verify.sh` | Live smoke | All with token |
| `AGENTS.md` | Agent contract | All |
| `FRONT_ONBOARD.md` | Equal onboard | All |
| `VERSION` | Semver | All |

Canonical GitHub product: `https://github.com/Daneshpajouh/mystorax-skills`  
Conductor SSoT: `https://mx.parallex.ca`
