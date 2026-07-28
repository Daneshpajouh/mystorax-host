---
name: mystorax-science-os
description: >
  MystoraX Science OS (Axiom campaigns) via Conductor — status, budgeted resume, allowlisted axiom tool proxy.
  Use for genomics/protein/campaign DEFINE→CERTIFY work. Auto-resume stops at EVIDENCE; never auto-CERTIFY.
---

# MystoraX Science OS

## Sequence

1. `mystorax_science_status`
2. `mystorax_submit_goal` with `job_class=science` (or resume existing campaign)
3. `mystorax_science_resume` — `max_phases` default 1, `max_auto_phase=EVIDENCE`
4. Bio tools: `mystorax_axiom_tool_search` → `mystorax_axiom_tool_call` (Conductor allowlist; fail-closed without Conductor-side token)

## Bounds

- Auto-advance through **EVIDENCE** only
- KILL_TEST → CERTIFY needs explicit operator/MCP approval
- Never silently downgrade SCIENCE to ordinary research
- Checkpoint shape: `(phase_id, artifact_type, content_hash, step_count, gate_status)`

## With any science front

Use Conductor Science OS tools regardless of UI (Claude Science specialist, Cursor, Codex, …).  
Auto-resume stops at **EVIDENCE**; never auto-CERTIFY.
