---
name: mystorax-hosts-manifest
description: >
  MystoraX live host manifest — tools, Hands health, doctrine pointers via
  GET /v1/hosts/manifest. Use when MCP is missing, for cold bootstrap, or to verify
  Hands/CLI readiness on any front.
---

# MystoraX Hosts Manifest

## Call

```bash
curl -fsS "$MYSTORAX_CONDUCTOR_URL/v1/hosts/manifest"
```

## Contains

- `conductor_http` — goal, routing-guide, surfaces, job status, wait stream
- `conductor_mcp` — tool names + facade note
- `chatgpt_actions_openapi` — OpenAPI URL
- `hands_health` — which CLIs are runnable
- `surfaces_summary` — wired / guided / refused counts
- `doctrine_version` — e.g. `mystorax.front_agnostic.v1`
- `discovery_sequence` — ordered first calls

## After manifest

Still call `mystorax_routing_guide` before non-trivial goals.

MCP fronts use `mystorax_hosts_manifest`; HTTP fronts use the curl call above. Use this for cold bootstrap and liveness, then follow the advertised discovery sequence.
