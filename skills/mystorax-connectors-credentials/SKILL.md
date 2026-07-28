---
name: mystorax-connectors-credentials
description: >
  Wire MystoraX credentials and connectors on any front without embedding secrets.
  Use for MYSTORAX_HOST_TOKEN, MCP registration, OpenAPI Actions, or custom HTTP connectors.
---

# MystoraX Connectors & Credentials

## Front credentials (OK on any host)

- `MYSTORAX_HOST_TOKEN` — host ingress
- `MYSTORAX_CONDUCTOR_URL` — default `https://mx.parallex.ca`

## Conductor-only (never on the front)

- `MYSTORAX_AXIOM_MCP_TOKEN` / bio MCP bearer

## Connectors

See `connectors/mystorax-conductor.md` — MCP stdio, HTTP MCP tools/call, ChatGPT OpenAPI, custom connector UIs.

## Example env

`credentials.example.env` — placeholders only.
