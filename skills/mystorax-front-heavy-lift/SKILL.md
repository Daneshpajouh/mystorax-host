---
name: mystorax-front-heavy-lift
description: >
  Preserve front usage limits. Offload research, search, brainstorming, prior-art,
  synthesis, and estimand redesign to MystoraX author bridges via Conductor.
  Use for Claude Science, Claude Code, Cursor, Codex CLI, and any peer front.
---

# Front heavy lift (token conservation)

## Rule

Fronts **judge and ledger**. Bridges **research, search, brainstorm, synthesize**.

Do **not** burn Claude Science / Claude Code / Cursor / Codex / UI front tokens on
loops MystoraX already hosts (literature, design debate, multi-source search,
long synthesis, package drafting).

## What counts as heavy (must go to bridges)

- Literature / prior-art / web-grounded search
- Brainstorming rival estimands, falsifiers, designs
- Long synthesis or multi-source comparison
- Multi-file packages / repo drafts
- Deep redesign debates (e.g. enumerate-then-score vs raw mismatch)

## What stays on the front (cheap)

- Framing the next crisp goal
- Reading job status / artifacts
- Filing ledger claims, barriers, dissents, prereg hashes
- Thin Hands apply/download/check after a bridge artifact
- Smoke commands and tiny wires

## How (every front)

1. `GET /v1/routing-guide` (or `mystorax_routing_guide`)
2. `POST /v1/goal` / `mystorax_submit_goal` with:
   - `job_class`: `research` | `planning` (**not** `science` — that opens a campaign)
   - `effort`: `high` | `xhigh` when the ask is hard
   - `dispatch`: true, `async_mode`: true
   - `bridge_opts`: mode/sources/worker hint (e.g. Perplexity `research` + `academic`)
   - One multi-step goal text — do not fragment
3. Wait/wake: `GET /v1/jobs/{id}/status` — do **not** re-reason while waiting
4. Apply results to the Science ledger / Hands only

If status is `done` but top-level prose looks empty, check `bridge.provider`.
`science_os` means a campaign checkpoint was created — wrong class for brainstorm.
Re-submit with `job_class=research`.

## Hands / CLI models

When a thin CLI Hand or CLI model faces a HEAVY ask, it **submits a Conductor
goal to author bridges** — it does not answer research/brainstorm from its own
context. Hands remain apply/download/check after the bridge returns.

## Anti-patterns

- Front-local multi-round literature review while Conductor is reachable
- Fragmenting one design debate into many tiny front asks
- Busy-looping Hands while bridges think
- Calling bridge URLs directly (always Conductor)

## Related

`mystorax-platform`, `mystorax-routing`, `mystorax-submit-goal`, `mystorax-wait-wake`,
`mystorax-bridges-authors`, `mystorax-author-session`, `mystorax-science-os`.
