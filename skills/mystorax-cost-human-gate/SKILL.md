---
name: mystorax-cost-human-gate
description: >
  MystoraX cost park and human-gate lifecycle — budget exhaust requires revise_scope or add_funds;
  irreversible Hands need approval; expired/revoked/conflicted gates park/escalate (no hang).
---

# MystoraX Cost + Human Gate

## Cost

- Soft-warn near ceiling; hard-halt parks the goal (`success: false`)
- Resume only after **revise_scope** or **add_funds**
- Durable ledger under Conductor `state/cost-ledger` — not `app/.data`

## Human gate

Statuses: pending | approved | expired | revoked | conflicted | parked | rejected

- Irreversible Hands require approved gate
- Ignored/expired/revoked/conflicted → park + escalate (deterministic)

HTTP (host token): `/v1/goals/human_gate/*`, `/v1/goals/cost/*` (Round-9/10 routes).
