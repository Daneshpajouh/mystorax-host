# MystoraX Host Package

**Installable** front-agnostic package for MystoraX Conductor: plugins + skills + rules + commands + MCP server + OpenAPI/Actions connector.

**MystoraX** is the platform. Cursor, Claude Code, Claude Science, Codex, ChatGPT, Gemini-as-UI, and HTTP are **peer fronts** — equal; none owns doctrine.

| Component | What you get |
|-----------|----------------|
| **Cursor plugin** | Skills, rules, agents, slash commands, MCP |
| **Claude plugin** | Skills + MCP + marketplace entry + `claude --plugin-dir` |
| **Codex plugin** | Skills + MCP |
| **MCP server** | `mystorax-conductor` stdio facade (also `pip install -e .`) |
| **OpenAPI connector** | ChatGPT Actions (`openapi/conductor.openapi.yaml` + live URL) |
| **HTTP connector** | Raw curl / custom clients (`connectors/`) |
| **Verify / uninstall** | `./verify.sh` · `./uninstall.sh` |

Capability lives on Conductor: `https://mx.parallex.ca`.

Repo: [`Daneshpajouh/mystorax-skills`](https://github.com/Daneshpajouh/mystorax-skills) · Version [`VERSION`](VERSION)

Optional bio pack: [`axiom-science-os`](https://github.com/Daneshpajouh/axiom-science-os) (orthogonal).

## One-command install

```bash
git clone https://github.com/Daneshpajouh/mystorax-skills.git
cd mystorax-skills
export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
./install.sh
./verify.sh
```

Claude Science: Skills → Import from GitHub → `Daneshpajouh/mystorax-skills` (equal peer).  
ChatGPT: Import OpenAPI → see `connectors/chatgpt-actions.md`.

## Discovery (every front)

1. `mystorax_routing_guide` / `GET /v1/routing-guide`
2. `mystorax_surfaces` / `GET /v1/surfaces`
3. `mystorax_submit_goal` / `POST /v1/goal`
4. Cold bootstrap: `GET /v1/hosts/manifest`

## Package layout

```
.cursor-plugin/     Cursor manifest (skills, rules, commands, agents, MCP)
.claude-plugin/     Claude plugin + marketplace.json
.codex-plugin/      Codex manifest
.mcp.json           MCP stdio entry
rules/              Always-on doctrine
commands/           Slash commands
skills/             Portable SKILL.md set
agents/             Platform lead agent
connectors/         MCP + OpenAPI + HTTP recipes
openapi/            Conductor OpenAPI snapshot
python/             pip package mystorax-conductor-mcp
scripts/            MCP server + OpenAPI refresh
install.sh          Full local install
uninstall.sh        Remove local install
verify.sh           Live smoke
AGENTS.md           Agent contract
FRONT_ONBOARD.md    Equal onboard for every front
```

## Doctrine (locked)

| Rule | Detail |
|------|--------|
| SSoT | Conductor HTTP |
| Files | Perplexity + ChatGPT only |
| Gemini | Text / long-context only |
| Hands | Thin `gemini → copilot → codex → cursor-agent → claude` |
| Science | Auto-stop at **EVIDENCE**; never auto-CERTIFY |
| Authors | One long session; escalate before provider switch |
| Sources | Perplexity default `web`; select academic/github/hf/cf |
| Refuse | Computer / ASI / agentic_research / Spark / local LLM / agy |
| Secrets | Never commit tokens |

## Docs

- [`FRONT_ONBOARD.md`](FRONT_ONBOARD.md) — per-front install
- [`AGENTS.md`](AGENTS.md) — operator contract
- [`PACKAGE.md`](PACKAGE.md) — component matrix
- [`connectors/mystorax-conductor.md`](connectors/mystorax-conductor.md) — MCP / HTTP
- [`connectors/chatgpt-actions.md`](connectors/chatgpt-actions.md) — Actions
