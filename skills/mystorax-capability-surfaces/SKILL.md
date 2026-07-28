---
name: mystorax-capability-surfaces
description: >
  MystoraX surfaces catalog — wired / guided / inventory / refused / deferred capabilities.
  Use mystorax_surfaces or mystorax_capability_lookup before claiming a feature exists.
---

# MystoraX Capability Surfaces

## Tools

- `mystorax_surfaces` — full catalog (+ optional status filter)
- `mystorax_capability_lookup` — keyword / id substring

## HTTP

- `GET /v1/surfaces`
- Routing guide embeds `capability_registry` (hard_refused + inventory_only)

## Rules

- **wired** = safe to use via Conductor
- **inventory_only** = visible, not Hands-dispatchable
- **refused** = HARD fail-closed — never fake success
- Flags ≠ universal capability; compound kill-tests still bound claims
