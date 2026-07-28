---
name: mystorax-verify
description: Verify MystoraX host package connectivity (manifest + tiny goal).
---

# /mystorax-verify

Run pack `./verify.sh` if available, otherwise:

1. `GET /v1/hosts/manifest`
2. `mystorax_routing_guide`
3. Submit goal: `Reply with exactly: MYSTORAX_OK`

Report pass/fail. Never invent bridge URLs.
