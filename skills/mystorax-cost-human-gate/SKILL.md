---
name: mystorax-cost-human-gate
description: >
  MystoraX cost ceilings and human-in-the-loop gates — soft warn, hard halt/park,
  HITL inject, certify approval. Use when budgets or approvals block progress.
---

# MystoraX Cost & Human Gates

## Cost

- Soft warn may continue with `cost_soft_warn` metadata
- Hard halt / park returns fail-closed HTTP (often 402) — do not retry blindly
- Prefer lower effort or shorter goals after halt

## Human gates

- HITL inject: `metadata.hitl_inject` mid-run
- Science CERTIFY: explicit `certify_approval` / operator record required
- Author step ceiling: HTTP 409 — operator escalation required

## Never

Bypass gates by switching fronts or inventing local compute.
