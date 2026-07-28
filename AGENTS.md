# MystoraX — agent contract (any front)

You are a **front**. Capability lives on **Conductor**.

## Always

1. Discover: `mystorax_routing_guide` → `mystorax_surfaces` (or HTTP equivalents).
2. Prefer `mystorax_submit_goal` / `POST /v1/goal` over calling bridges or CLIs directly.
3. Keep multi-step / whole-project work in **one** author session (dozens–200+ steps). Do not fragment.
4. Files → ChatGPT or Perplexity only. Gemini goals stay text-only.
5. Hands = thin apply/download/check after bridge artifacts. Order: `gemini → copilot → codex → cursor-agent → claude`.
6. Science auto-resume stops at **EVIDENCE**. Never auto-CERTIFY.
7. Refuse Computer / ASI / agentic_research / Spark / local LLM / agy execute. Fail closed.
8. Never invent bridge URLs or commit secrets.

## Bootstrap without MCP

`GET https://mx.parallex.ca/v1/hosts/manifest`

## Auth

Bearer `MYSTORAX_HOST_TOKEN`. Same token for every front.
