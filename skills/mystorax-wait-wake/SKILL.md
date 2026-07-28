---
name: mystorax-wait-wake
description: >
  MystoraX durable wait-wake for long bridge/science jobs — SSE hints and job status polling.
  Use instead of burning Hands CLI tokens while ChatGPT/Perplexity/Gemini run for minutes or hours.
---

# MystoraX Wait-Wake

1. After `mystorax_submit_goal`, keep `job_id` / `wait_id`
2. `mystorax_wait_stream_hint` for SSE recipe
3. Or poll `mystorax_job_status`
4. Re-enter with continuation / cold resume only via Conductor APIs

Do not open unofficial websocket scrapers to provider UIs from Hands.
