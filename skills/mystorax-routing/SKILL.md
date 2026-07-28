---
name: mystorax-routing
description: >
  MystoraX routing doctrine — which author bridge, Hands lane, and effort to use.
  Use before non-trivial goals; prefer mystorax_routing_guide over memory.
---

# MystoraX Routing

## Call first

`mystorax_routing_guide` or `GET /v1/routing-guide`

## Authors

| Bridge | Fast | Deep | Files | Lead when |
|--------|------|------|-------|-----------|
| Perplexity | hard/web | research / deep-research | yes | citations, live web, hard+fast |
| ChatGPT | auto / instant | thinking / pro (may take hours) | yes | multi-step projects, packages |
| Gemini | Flash | Thinking / Pro | **no** | long-context text, failover |

## Hands (thin only)

`gemini → copilot → codex → cursor-agent → claude`

No MCP/skills/plugins/agy as Hands. Missing CLIs are not capacity.

## Effort

Conductor `effort` maps per worker (`native_depth`). Never invent shared model names across bridges.

## Anti-fragment

Do not split whole-project work into tiny asks. Prefer 50–200+ steps in one author session.
Escalate ChatGPT depth (auto→thinking→pro) before switching providers.
Soft warn ~150 steps; ceiling ~200 → checkpoint; HTTP 409 at ceiling requires operator escalation.
