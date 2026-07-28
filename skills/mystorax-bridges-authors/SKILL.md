---
name: mystorax-bridges-authors
description: >
  MystoraX author bridges — ChatGPT, Perplexity, Gemini roles and file rules.
  Use when choosing which bridge should author a goal.
---

# MystoraX Bridges (authors)

Bridges **author**. Hands **apply**. Fronts never talk to bridge URLs directly — use Conductor.

| Bridge | Strength | Files | Avoid |
|--------|----------|-------|-------|
| Perplexity | Hard web, citations, research modes | yes | Computer / ASI / agentic_research |
| ChatGPT | Multi-step packages, excellence, long thinking | yes | Treating connectors as unbounded SSoT |
| Gemini | Long context, multimodal text | **no** | File packages, Computer Use, Spark |

## Modes (hints via bridge_opts)

- Perplexity: `auto` / `research` / `deep-research` / `pro` — never Computer
- ChatGPT: `auto` / thinking / pro — escalate before switch
- Gemini: text modes only

## Sources

Perplexity: see `mystorax-perplexity-sources`. Default web-only.
