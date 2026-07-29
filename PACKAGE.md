# MystoraX host package — component matrix

Product: **mystorax-host** v2.3.0 (not a skills-only repo).

| Path | Component | Fronts |
|------|-----------|--------|
| `.cursor-plugin/plugin.json` | Cursor plugin | Cursor |
| `.claude-plugin/plugin.json` | Claude plugin | Claude Code, Claude Science |
| `.claude-plugin/marketplace.json` | Claude marketplace | Claude Code |
| `.codex-plugin/plugin.json` | Codex plugin | Codex |
| `.mcp.json` | MCP wiring | Cursor, Claude, Codex |
| `rules/` | Always-on doctrine | Cursor |
| `commands/` | Slash commands | Cursor, Claude |
| `skills/` | Doctrine modules (Agent Skills wire format — not the product name) | Cursor / Claude / Codex |
| `agents/` | Platform lead | Cursor, Claude, Codex |
| `scripts/conductor_mcp_server.py` | MCP server | MCP fronts |
| `python/mystorax_conductor_mcp/` | pip MCP connector | Any Python host |
| `openapi/conductor.openapi.yaml` | OpenAPI connector | ChatGPT Actions |
| `connectors/cursor.md` | Cursor recipe | Cursor |
| `connectors/claude-code.md` | Claude Code recipe | Claude Code |
| `connectors/claude-science.md` | Claude Science recipe | Claude Science |
| `connectors/codex.md` | Codex recipe | Codex |
| `connectors/chatgpt-actions.md` | OpenAPI Actions | ChatGPT |
| `connectors/perplexity-front.md` | Perplexity UI front | Perplexity |
| `connectors/gemini-front.md` | Gemini UI front | Gemini |
| `connectors/http.md` | Raw HTTP | Any |
| `connectors/mystorax-conductor.md` | Transport overview | All |
| `FRONT_ONBOARD.md` / `FRONT_MATRIX.md` | Equal-peer onboard | All |
| `install.sh` / `uninstall.sh` / `verify.sh` | Lifecycle | Local installs |
| `AGENTS.md` | Agent contract | All |

Canonical: `https://github.com/Daneshpajouh/mystorax-host`  
SSoT: `https://mx.parallex.ca`

Task-first module map: [`MODULE_INDEX.md`](MODULE_INDEX.md)
Machine-readable module contract: [`modules.json`](modules.json) — exactly 16 modules (includes `mystorax-front-heavy-lift`).
