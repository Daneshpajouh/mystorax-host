---
name: mystorax-capability-surfaces
description: >
  MystoraX surfaces catalog — wired / guided / inventory / refused / deferred.
  Use mystorax_surfaces or mystorax_capability_lookup before claiming a feature exists.
---

# MystoraX Capability Surfaces

## Tools

- `mystorax_surfaces` — full catalog (+ optional status filter)
- `mystorax_capability_lookup` — keyword / id substring

## HTTP

- `GET /v1/surfaces`
- Routing guide embeds `capability_registry` (hard_refused + inventory_only)

## Status meanings

| Status | Meaning |
|--------|---------|
| **wired** | Safe via Conductor |
| **guided** | Documented path; follow guide |
| **inventory** | Visible, not Hands-dispatchable |
| **refused** | HARD fail-closed — never fake success |

Flags ≠ universal capability. Compound kill-tests still bound claims.

Use before claiming or dispatching a capability: `mystorax_surfaces` or `mystorax_capability_lookup`; HTTP clients call `GET /v1/surfaces`. Example: look up `computer` and honor the returned refused status.
