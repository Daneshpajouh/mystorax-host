---
name: mystorax-submit-goal
description: >
  Submit work to MystoraX Conductor via mystorax_submit_goal / POST /v1/goal.
  Use for research, coding packages, science campaigns, and ops — instead of calling bridges or CLIs directly.
---

# MystoraX Submit Goal

## Preferred tool

`mystorax_submit_goal` with:

- `text` — full goal (do not fragment multi-step projects)
- `job_class` — research | coding | planning | science | ops
- `effort` — low | medium | high | xhigh
- `worker` — optional hint (chatgpt | perplexity | gemini | codex | …)
- `dispatch` — true to run

## HTTP equivalent

```bash
curl -fsS -X POST "$MYSTORAX_CONDUCTOR_URL/v1/goal" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"text":"...","job_class":"research","effort":"high","host":"cursor","dispatch":true}'
```

## After accept

- Poll `mystorax_job_status` or use `mystorax_wait_stream_hint` (SSE)
- Do not spin Hands CLIs waiting on bridge latency

## Attachments / files

- Route file packages to **chatgpt** or **perplexity**
- Gemini goals must stay text-only (Conductor fail-closes file mismatch)
