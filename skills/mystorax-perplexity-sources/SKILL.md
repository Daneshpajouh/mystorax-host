---
name: mystorax-perplexity-sources
description: >
  Select Perplexity sources through Conductor bridge_opts.sources or
  metadata.sources. Default to web-only and keep Notion opt-in.
---

# MystoraX Perplexity Sources

## Default

Omit the source list, or use `sources: ["web"]`, for public web-only research. Organization connectors such as Notion stay off unless explicitly selected.

## Selectors

| Canonical | Accepted alias |
|---|---|
| `web` | internet |
| `academic` | scholar, scholarly, papers |
| `github` | gh |
| `huggingface` | `hf`, hugging_face |
| `cloudflare` | `cf` |
| `notion` | notion, opt-in only |

## Request shape

```json
{
  "worker": "perplexity",
  "bridge_opts": {
    "sources": ["academic", "github"]
  },
  "metadata": {
    "sources": ["academic", "github"]
  }
}
```

Use either location when the host supports only one. When both are present, keep them consistent.

## Boundaries

- Do not turn on Notion by default.
- Do not pass unsupported source names.
- Do not use Computer, computer-use, ASI, Tasks, Tasks credits, or agentic research as sources or modes.
- Preserve the selected source list in the goal metadata and handoff.
