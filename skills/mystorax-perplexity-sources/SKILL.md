---
name: mystorax-perplexity-sources
description: >
  Select Perplexity ask sources via Conductor bridge_opts/metadata. Default web-only
  (blocks Notion leak). Prefer academic, github, huggingface, cloudflare when needed.
---

# MystoraX Perplexity Sources

## Default

`sources: ["web"]` — public web only. Organization connectors (e.g. Notion) stay off unless selected.

## Preferred selectors

| Id | Aliases |
|----|---------|
| `academic` | scholar, scholarly, papers |
| `github` | gh |
| `huggingface` | hf, hugging_face |
| `cloudflare` | cf |
| `web` | internet |
| `notion` | notion (opt-in only) |

## How to pass

```json
{
  "worker": "perplexity",
  "bridge_opts": { "sources": ["academic", "github"], "mode": "research" },
  "metadata": { "prefer": "perplexity", "sources": ["academic", "github"] }
}
```

Academic in sources also sets search focus to academic when unset.

## Refused

Never pass `computer`, `computer_use`, `asi`, `tasks`, or agentic research as sources — burns paid Computer credits; Conductor/bridges fail closed.

Use with `mystorax_submit_goal` / `POST /v1/goal`; put selectors in `bridge_opts.sources`. Example: `{"bridge_opts":{"sources":["academic","github"]}}`.
