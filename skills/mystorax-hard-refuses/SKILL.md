---
name: mystorax-hard-refuses
description: >
  MystoraX HARD_REFUSED capabilities — Computer, ASI, agentic research, Spark, local LLM,
  agy execute. Always fail closed; never fake success on any front.
---

# MystoraX Hard Refuses

Fail closed. Do not soft-fallback into these.

## Refused surface ids (canonical)

- `perplexity.computer` / `perplexity.computer_use` / `perplexity.asi` / `perplexity.agentic_research`
- `gemini.computer_use` / `gemini.spark_launch`
- `local_llm` / `local_llm.ollama` / `local_llm.mlx` / `local_llm.gemma` / `local_llm.opencode`
- `agy.execute` / `agy.agent` / `agy.agents` / `agy.plugin` / `agy.plugins`

## Operator language that must refuse

Computer Use, Tasks credits, ASI, agentic research, Spark launch, “run local LLM as Hands”, agy execute.

## Check live

`mystorax_surfaces` / `mystorax_capability_lookup` and routing guide `capability_registry.hard_refused`.

Use before ambiguous routing. Call `mystorax_capability_lookup` or `GET /v1/surfaces`; if refused, return the refusal and do not call `mystorax_submit_goal`.
