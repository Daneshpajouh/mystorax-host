---
name: mystorax-author-session
description: >
  Keep MystoraX author work in ONE multi-step bridge session. Escalate depth before
  switching providers. Use for projects, packages, and long research — never fragment.
---

# MystoraX Author Session

## Rules

1. Bridges own whole-project / many-iteration work in **one** session (dozens to 200+ steps).
2. Do **not** fragment into tiny one-step asks.
3. Escalate ChatGPT depth (`auto` → `thinking` → `pro`) before switching providers.
4. Soft warn near ~150 steps; ceiling ~200 before a voluntary checkpoint.
5. When `author_session.at_ceiling` is true, Conductor returns **HTTP 409**
   `author_step_ceiling_reached` — operator escalation required (no silent restart).
6. Science checkpoints use `(phase_id, artifact_type, content_hash, step_count, gate_status)`.

## Continuity

Prefer `metadata.author_session` / wait-wake resume over starting a new thread.
Provider switch requires escalate-first; session survives wait/wake via job payload.

## Related

`mystorax-routing`, `mystorax-submit-goal`, `mystorax-wait-wake`, `mystorax-bridges-authors`.
