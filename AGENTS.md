# MystoraX Operator Contract

1. Bootstrap with `GET /v1/hosts/manifest`.
2. Read `GET /v1/routing-guide`.
3. Inspect `GET /v1/surfaces`.
4. Submit work through `POST /v1/goal` or `mystorax_submit_goal`.
5. Treat Conductor HTTP as the capability, routing, admission, and durable-state source of truth.
6. Keep every front thin and equal. Do not contact or invent bridge URLs.
7. Keep multi-step work in one author session. Escalate depth before switching authors.
8. Authors create complete outputs. Hands only apply, download, and check.
9. Hands order is `gemini -> copilot -> codex -> cursor-agent -> claude`.
10. File packages may come only from Perplexity or ChatGPT. Gemini is text-only.
11. Perplexity defaults to web-only. Select `academic`, `github`, `huggingface` or `hf`, `cloudflare` or `cf`, and opt-in `notion` only through `bridge_opts.sources` or `metadata.sources`.
12. Refuse Computer, ASI, `agentic_research`, Tasks credits, Spark, local LLM, and `agy execute`.
13. Science auto-resume stops at `EVIDENCE`. Never auto-CERTIFY.
14. Respect cost ceilings, parked goals, idempotency, provenance, and human gates.
15. Keep credentials in environment variables or the front's credential UI. Never persist them in repository or MCP config files.
16. Preserve durable IDs, evidence, checkpoints, costs, gates, and provenance in every handoff.
