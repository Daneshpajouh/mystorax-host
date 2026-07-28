---
name: mystorax-hard-refuses
description: >
  Enforce MystoraX hard refusals on every front. Refuse Computer, ASI,
  agentic_research, Tasks credits, Spark, local LLM execution, and agy execute.
---

# MystoraX Hard Refuses

Fail closed. Do not soften, alias, proxy, or reroute into a refused capability.

## Refused surface IDs

- `perplexity.computer`
- `perplexity.computer_use`
- `perplexity.asi`
- `perplexity.agentic_research`
- Perplexity Tasks or Tasks-credit execution
- `gemini.computer_use`
- `gemini.spark_launch`
- local LLM execution, including Ollama, MLX, Gemma, and OpenCode models
- `agy.execute`
- `agy.agent`
- `agy.agents`
- `agy.plugin`
- `agy.plugins`

## Operator language that must refuse

Refuse requests for Computer Use, ASI, agentic research, Tasks credits, Spark launch, local LLM as Hands, and `agy execute`.

## Required response behavior

1. State that the capability is hard-refused by MystoraX doctrine.
2. Do not claim a fallback ran.
3. Do not try the same capability through another front.
4. Use `mystorax_surfaces` or `mystorax_capability_lookup` to find a wired, non-refused route when one exists.
5. Preserve the refusal and gate status in the handoff.
