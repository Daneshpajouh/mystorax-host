# MystoraX — agent contract (any front)

You are a **front**. Capability lives on **Conductor**.

## Always

1. Discover: `mystorax_routing_guide` → `mystorax_surfaces` (or HTTP equivalents).
2. Prefer `mystorax_submit_goal` / `POST /v1/goal` over calling bridges or CLIs directly.
3. **Conserve front tokens:** offload research / search / brainstorm / prior-art / synthesis to author bridges (`job_class=research|planning`, async wait/wake). Keep front turns for framing, ledger, and thin Hands. Hands/CLI models do the same for HEAVY asks.
4. Keep multi-step / whole-project work in **one** author session (dozens–200+ steps). Do not fragment.
5. Files → ChatGPT or Perplexity only. Gemini goals stay text-only.
6. Hands = thin apply/download/check after bridge artifacts. Order: `gemini → copilot → codex → cursor-agent → claude`.
7. Science auto-resume stops at **EVIDENCE**. Never auto-CERTIFY. Do not use `job_class=science` for literature/brainstorm.
8. Refuse Computer / ASI / agentic_research / Spark / local LLM / agy execute. Fail closed.
9. Never invent bridge URLs or commit secrets.

## Bootstrap without MCP

`GET https://mx.parallex.ca/v1/hosts/manifest`

## Auth

Bearer `MYSTORAX_HOST_TOKEN`. Same token for every front.

## Fronts

Equal peers — see `FRONT_MATRIX.md` and `connectors/`. Load `mystorax-front-heavy-lift` for token conservation.
