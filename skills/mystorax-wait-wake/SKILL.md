---
name: mystorax-wait-wake
description: >
  MystoraX durable async jobs — poll status or SSE wait streams instead of burning
  front tokens on long bridge work.
---

# MystoraX Wait / Wake

## After `submit_goal`

Async accept returns `job_id` / `wait_id`.

| Action | Path |
|--------|------|
| Status | `GET /v1/jobs/{job_id}/status` or `mystorax_job_status` |
| SSE | `GET /v1/waits/{wait_id}/stream` or `mystorax_wait_stream_hint` |
| Cancel | `POST /v1/jobs/{job_id}/cancel` |

## Rules

- Do not busy-loop Hands CLIs while bridges think
- Author sessions survive wait/wake via job `bridge_payload.author_session`
- On stall / ceiling: escalate or checkpoint — never silent truncate

After submission, call `mystorax_job_status` / `GET /v1/jobs/{job_id}/status`; for long waits use `mystorax_wait_stream_hint` / `GET /v1/waits/{wait_id}/stream`. Cancel only with the documented job cancel route.
