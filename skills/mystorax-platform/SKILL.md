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
| RESEARCH / PLANNING | Author bridges (profile + model/mode) |
| CODING heavy | ONE multi-step bridge session, then thin Hands |
| CODING light | Hands only |
| OPS | oci |

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
| Refuse | Computer / ASI / agentic_research / Spark / local LLM / agy execute |
| Honesty | Broad ≠ universal; HARD_REFUSED fail closed |

## Related skills

`mystorax-routing`, `mystorax-submit-goal`, `mystorax-author-session`, `mystorax-bridges-authors`, `mystorax-perplexity-sources`, `mystorax-hands-thin`, `mystorax-hard-refuses`, `mystorax-science-os`, `mystorax-front-onboard`, `mystorax-hosts-manifest`, `mystorax-capability-surfaces`.

## Bio pairing

Optional: `axiom-science-os` for domain bio skills/MCP. Conductor remains platform ingress.
