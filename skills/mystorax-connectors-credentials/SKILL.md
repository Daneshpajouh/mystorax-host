---
name: mystorax-connectors-credentials
description: >
  MystoraX credentials and connectors — host bearer, optional axiom token, ChatGPT
  connector allowlist. Never commit secrets. Same model on every front.
---

# MystoraX Connectors & Credentials

## Required (every front)

| Env | Purpose |
|-----|---------|
| `MYSTORAX_CONDUCTOR_URL` | default `https://mx.parallex.ca` |
| `MYSTORAX_HOST_TOKEN` | Bearer host ingress (writes / goals) |

Local file (never commit): `~/.mystorax/secrets/host_ingress_token`

## Optional

| Env | Purpose |
|-----|---------|
| `MYSTORAX_AXIOM_MCP_TOKEN` | Conductor-side bio MCP proxy only |

## ChatGPT connectors

Allowlisted at Conductor (`gmail`, `drive`, `github`, `notion`, …). Deny-by-default for unknown connectors.

## Perplexity sources

Not ChatGPT connectors — use `sources` ask field. See `mystorax-perplexity-sources`.

## Never

- Commit tokens into `.mcp.json`, OpenAPI configs, or skills
- Put Axiom tokens on the front when Conductor already holds them
- Point connectors at Computer / ASI / local LLM

## Invoke

Before a write call, bootstrap with HTTP `GET /v1/hosts/manifest` (no manifest MCP tool). MCP reads the existing token-file reference at runtime; HTTP sends `Authorization: Bearer …`. Never move the secret into package configuration.
