---
name: mystorax-submit-goal
description: Submit a goal to MystoraX Conductor (platform-first).
---

# /mystorax-submit-goal

Submit the user's request to MystoraX via `mystorax_submit_goal` or `POST /v1/goal`.

## Steps

1. Call `mystorax_routing_guide` if not already loaded this session.
2. Build one complete goal text (do not fragment multi-step projects).
3. Choose `job_class` + `effort`; optional `worker` hint.
4. For Perplexity, set `bridge_opts.sources` (default web-only).
5. Dispatch and report `job_id` / wait URLs.

Arguments: $ARGUMENTS
