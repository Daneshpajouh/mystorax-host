# Gemini as a front

## Role

Gemini can be:

| Role | Meaning |
|------|---------|
| **Bridge (text)** | Conductor routes text / long-context goals to Gemini. **No file packages.** |
| **Human UI front** | You chat in Gemini and want MystoraX — use a companion MCP/HTTP front to submit goals. |

## As a human front

1. Install `mystorax-host` on Cursor/Claude/Codex **or** use `connectors/http.md`.
2. Submit text-only goals via Conductor (`job_class=research|planning`, Gemini-friendly).
3. For zip/PDF/repo packages, Conductor must author via **ChatGPT or Perplexity**, not Gemini.

## Custom instructions (optional)

```
MystoraX Conductor is the SSoT (https://mx.parallex.ca).
You are a peer front. Prefer POST /v1/goal via companion.
Text/long-context only from Gemini; never claim file-package authorship.
Refuse Computer / ASI / Spark / local LLM / agy.
```

## Smoke

Low-effort text goal through Conductor; confirm no file artifact expected.
