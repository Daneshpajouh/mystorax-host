# mystorax-host

The complete, front-agnostic MystoraX host package: native plugins, MCP, OpenAPI, HTTP connectors, installers, rules, commands, agents, and 15 doctrine modules. Capability lives on the Conductor at `https://mx.parallex.ca`; no front owns doctrine.

## Start here — under 30 seconds

Prerequisite: your issued token already exists at `~/.mystorax/secrets/host_ingress_token`.

```bash
git clone https://github.com/Daneshpajouh/mystorax-host.git
cd mystorax-host
./install.sh --dry-run
./install.sh --front all
./install.sh --check
./verify.sh
```

The installer never copies the token value into MCP/plugin config. It registers Cursor, Claude Code, and Codex against the same package-local MCP bridge and syncs all doctrine modules to Claude/Codex skill directories. Its final checklist tells you exactly what to enable or reload.

`./verify.sh` proves health, manifest, routing, surfaces, and an accepted goal receipt. Use `./verify.sh --terminal --timeout 1200` when you also need to wait for bridge completion and an exact terminal `MYSTORAX_OK` marker.

First three calls on every capable front:

1. `mystorax_routing_guide` / `GET /v1/routing-guide`
2. `mystorax_surfaces` / `GET /v1/surfaces`
3. `mystorax_submit_goal` / `POST /v1/goal`

Cold bootstrap is HTTP-only: `GET /v1/hosts/manifest` (there is no separate manifest MCP tool).

## Pick your front

| Front | Transport | Copy/paste card |
|---|---|---|
| Cursor | native plugin + MCP | [`connectors/cursor.md`](connectors/cursor.md) |
| Claude Code | plugin/skills + MCP | [`connectors/claude-code.md`](connectors/claude-code.md) |
| Claude Science | GitHub skill pack + companion MCP/HTTP | [`connectors/claude-science.md`](connectors/claude-science.md) |
| Codex | plugin/skills + MCP | [`connectors/codex.md`](connectors/codex.md) |
| ChatGPT Desktop | imported OpenAPI or companion MCP where supported | [`connectors/chatgpt-actions.md`](connectors/chatgpt-actions.md) |
| ChatGPT Actions | live OpenAPI + Bearer | [`connectors/chatgpt-actions.md`](connectors/chatgpt-actions.md) |
| Perplexity UI | Space instructions + companion HTTP/MCP | [`connectors/perplexity-front.md`](connectors/perplexity-front.md) |
| Gemini UI | text-only instructions + companion HTTP | [`connectors/gemini-front.md`](connectors/gemini-front.md) |
| Raw HTTP | curl/any HTTP client | [`connectors/http.md`](connectors/http.md) |

Perplexity/Gemini UI are not falsely presented as native MCP clients. ChatGPT Actions requires the Action surface to reach the public HTTPS Conductor.

## What MystoraX can do

Use the task-first [`MODULE_INDEX.md`](MODULE_INDEX.md) to map a task to the exact doctrine module, MCP tool, HTTP route, and example. [`FRONT_MATRIX.md`](FRONT_MATRIX.md) states what each front can really use. The live [manifest](https://mx.parallex.ca/v1/hosts/manifest), routing guide, surfaces catalog, and [OpenAPI](https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml) remain authoritative.

Pack contents:

- `skills/`: 15 Agent Skills doctrine modules (wire format, not the product name)
- `rules/`, `commands/`, `agents/`: always-on and guided agent behavior
- `.cursor-plugin/`, `.claude-plugin/`, `.codex-plugin/`: native package manifests
- `scripts/conductor_mcp_server.py`: stdio MCP facade over Conductor HTTP
- `openapi/`: ChatGPT Action schema
- `connectors/`: nine peer-front cards
- `install.sh`, `verify.sh`, `uninstall.sh`: safe lifecycle

## Locked boundaries

- Conductor HTTP is the SSoT; prefer `POST /v1/goal`.
- Files: ChatGPT or Perplexity only. Gemini is text-only.
- Thin Hands order: `gemini → copilot → codex → cursor-agent → claude`.
- Science auto-stops at `EVIDENCE`; never auto-CERTIFY.
- HARD refuse Computer, ASI, `agentic_research`, Spark, local LLM, and `agy`.
- Chrome CDP handles asks; Comet handles Browser Control.
- Never commit or print secrets. No Apple runtime is required.

Version: [`VERSION`](VERSION) (`2.2.0`) · Package map: [`PACKAGE.md`](PACKAGE.md) · Onboarding contract: [`FRONT_ONBOARD.md`](FRONT_ONBOARD.md)
