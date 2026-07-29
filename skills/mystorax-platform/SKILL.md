---
name: mystorax-platform
description: >
  Umbrella MystoraX Conductor doctrine for every front (Cursor, Claude Code, Claude Science,
  Codex, ChatGPT, Gemini-as-UI, HTTP). Use when the user mentions MystoraX, Conductor,
  mx.parallex.ca, platform goals, bridges, Hands, or Science OS. Always call
  mystorax_routing_guide and mystorax_surfaces before inventing routes.
---

# MystoraX Platform

## Spine

Operator → Conductor `POST /v1/goal` → `route_job`

Fronts are interchangeable. Doctrine does not change per UI.

| Job class | Path |
|-----------|------|
| SCIENCE | Science OS campaign (DEFINE→CERTIFY) + bridge checkpoints |
| RESEARCH / PLANNING / BRAINSTORM | Author bridges (preserve front usage limits) |
| CODING heavy | ONE multi-step bridge session, then thin Hands |
| CODING light | Hands only |
| OPS | oci |

## Front token conservation

Fronts (Claude Science, Claude Code, Cursor, Codex CLI, UI peers) **offload**
research, search, brainstorming, prior-art, and long synthesis to MystoraX
author bridges via `POST /v1/goal`. The front frames the question, wait/wakes,
and applies ledger/Hands decisions — it does not redo the heavy loop locally.
Hands/CLI models follow the same rule for HEAVY work. See `mystorax-front-heavy-lift`.

## Discover first (all fronts)

1. `mystorax_routing_guide`
2. `mystorax_surfaces`
3. Prefer `mystorax_submit_goal`
4. Bootstrap: `GET /v1/hosts/manifest`

## Locked doctrine

| Rule | Detail |
|------|--------|
| Files | Perplexity + ChatGPT only |
| Gemini | Text / long-context only |
| Hands | Thin apply/download/check; skip unavailable |
| Science | Auto-stop at **EVIDENCE**; never auto-CERTIFY |
| Authors | Prefer one long session; escalate depth before provider switch |
| Front tokens | Offload research/search/brainstorm to bridges; front judges + ledgers |
| Refuse | Computer / ASI / agentic_research / Spark / local LLM / agy execute |
| Honesty | Broad ≠ universal; HARD_REFUSED fail closed |

## Related skills

`mystorax-routing`, `mystorax-submit-goal`, `mystorax-author-session`, `mystorax-bridges-authors`, `mystorax-perplexity-sources`, `mystorax-hands-thin`, `mystorax-hard-refuses`, `mystorax-science-os`, `mystorax-front-heavy-lift`, `mystorax-front-onboard`, `mystorax-hosts-manifest`, `mystorax-capability-surfaces`, `mystorax-wait-wake`.

## Bio pairing

Optional: `axiom-science-os` for domain bio skills/MCP. Conductor remains platform ingress.

## Invoke

For every non-trivial task, call `mystorax_routing_guide` / `GET /v1/routing-guide`, then `mystorax_surfaces` / `GET /v1/surfaces`, and submit through `mystorax_submit_goal` / `POST /v1/goal`.
