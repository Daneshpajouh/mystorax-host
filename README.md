# MystoraX Host Package

Installable **MystoraX** integration for every front: plugin + MCP + OpenAPI connector + doctrine + portable skill modules.

**MystoraX** is the product. Cursor, Claude Code, Claude Science, Codex, ChatGPT, Gemini-as-UI, and HTTP are **peer fronts** — equal; none owns doctrine.

| Component | What you get |
|-----------|----------------|
| **Cursor plugin** | Rules, agents, commands, skill modules, MCP |
| **Claude plugin** | Plugin dir + marketplace entry + MCP |
| **Codex plugin** | Plugin + MCP |
| **MCP connector** | `mystorax-conductor` stdio (`pip install -e .`) |
| **OpenAPI connector** | ChatGPT Actions (`openapi/conductor.openapi.yaml`) |
| **HTTP connector** | Raw curl / custom clients |
| **Installers** | `./install.sh` · `./verify.sh` · `./uninstall.sh` |

Capability lives on Conductor: `https://mx.parallex.ca`.

- Repo: [`Daneshpajouh/mystorax-host`](https://github.com/Daneshpajouh/mystorax-host)
- Version: [`VERSION`](VERSION) (`2.0.0`)
- Optional bio pack: [`axiom-science-os`](https://github.com/Daneshpajouh/axiom-science-os) (orthogonal)

> Formerly published as `mystorax-skills`. That name is retired — this is the host package.

## Install

```bash
git clone https://github.com/Daneshpajouh/mystorax-host.git
cd mystorax-host
export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
./install.sh
./verify.sh
```

| Front | How |
|-------|-----|
| Cursor / Claude Code / Codex | `./install.sh` |
| Claude Science | Import from GitHub → `Daneshpajouh/mystorax-host` |
| ChatGPT | OpenAPI → `connectors/chatgpt-actions.md` |
| HTTP / any agent | Bearer token + `POST /v1/goal` |

Equal-weight steps: [`FRONT_ONBOARD.md`](FRONT_ONBOARD.md) · Agent contract: [`AGENTS.md`](AGENTS.md) · Matrix: [`PACKAGE.md`](PACKAGE.md)

## Discovery (every front)

1. `mystorax_routing_guide` / `GET /v1/routing-guide`
2. `mystorax_surfaces` / `GET /v1/surfaces`
3. `mystorax_submit_goal` / `POST /v1/goal`
4. Cold bootstrap: `GET /v1/hosts/manifest`

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
