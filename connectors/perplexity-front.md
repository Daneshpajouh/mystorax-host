# Perplexity as a front

Two different roles — do not confuse them:

| Role | Meaning |
|------|---------|
| **Bridge author** | Conductor routes goals *to* Perplexity (files, web, multi-step). Platform-internal. |
| **Human front** | You work in the Perplexity UI and want MystoraX capability. |

## As a human front

Perplexity UI does not host MystoraX Actions. Use:

1. **Companion transport** (recommended): Cursor / Claude / Codex / curl with `mystorax-host` installed; submit goals to Conductor while using Perplexity for reading.
2. **Space / custom instructions**: paste doctrine from `AGENTS.md` + HTTP recipe from `connectors/http.md` so Perplexity *formulates* Conductor goals; the companion executes `POST /v1/goal`.

## Suggested Space instructions (paste)

```
You are a front for MystoraX. Capability lives on Conductor https://mx.parallex.ca.
Never claim Computer, ASI, agentic research, Spark, or local LLM.
Prefer one multi-step goal; files only via ChatGPT or Perplexity bridges.
Science stops at EVIDENCE. Formulate goals for POST /v1/goal; do not invent bridge URLs.
```

## Sources (when Conductor uses Perplexity bridge)

Default `web`. Selectable: academic, github, huggingface, cloudflare. Notion opt-in only.

## Card

Auth stays in the companion token file. First calls are routing guide, surfaces, then submit goal. Load `mystorax-platform`, `mystorax-perplexity-sources`, and the task module from `MODULE_INDEX.md`. Smoke with companion `./verify.sh`.

Fixes: no HTTP tool in the UI → use curl/native companion; sources wrong → set `bridge_opts.sources`; file work must route through the Perplexity or ChatGPT author bridge. This is a documented UI/companion path, not a claim of native Perplexity MCP.

## HARD refuse

Never request Perplexity Computer / ASI / agentic_research / computer_use.
