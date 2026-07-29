---
name: mystorax-science-os
description: >
  MystoraX Science OS campaigns — durable DEFINE→CERTIFY with budgeted resume.
  Auto-resume stops at EVIDENCE; never auto-CERTIFY. Works on every front.
---

# MystoraX Science OS

## Spine

Durable campaign state. Bridges author phase material into checkpoints with
`(phase_id, artifact_type, content_hash, step_count, gate_status)`.

## Tools

- `mystorax_science_status`
- `mystorax_science_resume` — advances up to `max_phases` (default 1) through PRIOR_ART→EVIDENCE

## Locked gates

- Auto-resume **stops at EVIDENCE** (`max_auto_phase`)
- Never auto-CERTIFY
- Past EVIDENCE (KILL_TEST→CERTIFY) needs explicit operator approval (approver, rationale, content_hash, gate)
- Do not silently drop SCIENCE into ordinary research on failure — mark degraded

## Front token conservation (Science)

Claude Science (and peer fronts) must **not** spend their own usage limits on
literature sweeps, brainstorming rival estimands, multi-source search, or long
synthesis. Submit those as Conductor goals to author bridges
(`job_class=research|planning`, async wait/wake). Keep front turns for:

- Framing the next falsifiable question
- Filing claims / barriers / dissents / prereg
- Reading bridge artifacts and deciding the next measurement
- Thin Hands after a package lands

Load `mystorax-front-heavy-lift`. Prefer one multi-step bridge session over
many front-local reasoning loops.

## Bio MCP

`mystorax_axiom_tool_search` / `mystorax_axiom_tool_call` — allowlisted; fail closed until Conductor has axiom token. Optional pair pack: `axiom-science-os`.

Use `mystorax_science_status` to inspect and `mystorax_science_resume` to advance. HTTP-only fronts call `POST /v1/hosts/mcp/tools/call` with the same tool name and arguments. Never advance automatically past `EVIDENCE`. For research/brainstorm heavy lift, use `mystorax_submit_goal` / `POST /v1/goal` to bridges first.
