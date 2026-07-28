---
name: mystorax-hosts-manifest
description: >
  MystoraX live host manifest — tools, Hands health, doctrine pointers via GET /v1/hosts/manifest.
  Use when MCP is missing, for cold bootstrap, or to verify Hands/CLI readiness on any front.
---

# MystoraX Hosts Manifest

## Call

```bash
curl -fsS "$MYSTORAX_CONDUCTOR_URL/v1/hosts/manifest"
```

No auth required for the public manifest map on many deployments; write tools still need host bearer.

## Use for

- Cold start when MCP is not wired
- `hands_health` — which CLIs are actually runnable
- MCP tool inventory pointers (`/v1/hosts/mcp/tools`)
- Confirm Conductor is the SSoT before inventing routes

## After manifest

Still call `mystorax_routing_guide` before non-trivial goals.
