---
name: mystorax-submit-goal
description: >
  Submit work to MystoraX Conductor via mystorax_submit_goal / POST /v1/goal.
  Use for research, coding packages, science campaigns, and ops — instead of calling
  bridges or CLIs directly from any front.
---

# MystoraX Submit Goal

## Preferred tool

`mystorax_submit_goal` with:

| Field | Notes |
|-------|--------|
| `text` | Full goal — do not fragment multi-step projects |
| `job_class` | research \| coding \| planning \| science \| ops |
| `effort` | low \| medium \| high \| xhigh |
| `worker` | optional hint (chatgpt \| perplexity \| gemini \| …) |
| `dispatch` | true to run |
| `host` | front id (cursor, claude_code, chatgpt_desktop, custom, …) |
| `bridge_opts` | mode/model/via/sources — optional |
| `metadata` | prefer, sources, author_only, hard_ceiling_s, … |

## HTTP

```bash
curl -fsS -X POST "$MYSTORAX_CONDUCTOR_URL/v1/goal" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"text":"...","job_class":"research","effort":"high","host":"cursor","dispatch":true,"async_mode":true}'
```

## After accept

- Poll `mystorax_job_status` → `GET /v1/jobs/{id}/status`
- Or SSE: `mystorax_wait_stream_hint` → `/v1/waits/{id}/stream`
- Do not spin Hands CLIs waiting on bridge latency

## Files

Route file packages to **chatgpt** or **perplexity**. Gemini stays text-only (Conductor fail-closes mismatch).

## Perplexity sources

Pass `bridge_opts.sources` or `metadata.sources`, e.g. `["academic","github"]`. Default web-only. See `mystorax-perplexity-sources`.

Use for all governed work after discovery. MCP calls `mystorax_submit_goal`; HTTP calls `POST /v1/goal`. A successful async response returns a job/wait id for the wait-wake module.
