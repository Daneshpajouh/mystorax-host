# Claude Science connector

Claude Science is an **equal peer front** — not the owner of MystoraX doctrine.

## Install

1. Import from GitHub: `Daneshpajouh/mystorax-host`
2. Keep the issued credential at `~/.mystorax/secrets/host_ingress_token`; never paste it into the pack.
3. Connect via the installed companion MCP (`mystorax-conductor`) and/or HTTP using `connectors/mystorax-conductor.md`.

Optional orthogonal bio pack: `Daneshpajouh/axiom-science-os`  
Axiom tokens stay on Conductor; Science auto-resume stops at **EVIDENCE**.

## First calls

1. `mystorax_routing_guide` / `GET /v1/routing-guide`
2. `mystorax_surfaces` / `GET /v1/surfaces`
3. `mystorax_submit_goal` / `POST /v1/goal`

Load `mystorax-platform`, `mystorax-science-os`, and the task module from `MODULE_INDEX.md`.

## Doctrine reminders

- Prefer Conductor over calling bridges or CLIs directly
- Files → ChatGPT or Perplexity authors only
- Never auto-CERTIFY Science campaigns
- HARD refuse Computer / ASI / agentic_research / Spark / local LLM / agy

Smoke: run `./verify.sh` from the companion pack. Fixes: unavailable MCP → use the HTTP companion; missing bio tools → pair the optional Axiom pack; never bypass a missing credential.
