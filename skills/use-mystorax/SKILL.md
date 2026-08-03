---
name: use-mystorax
description: Use MystoraX as a provider-neutral access layer for invoking currently verified author platforms and local CLI agents. Trigger when a front needs to inspect the live MystoraX capability catalog, select an advertised adapter, submit text or a supported attachment, monitor or cancel a job, handle rate limits safely, or delegate work without inventing routing policy or unsupported options.
---

# Use MystoraX

MystoraX is a thin execution layer. The calling front owns the task and uses
only capabilities advertised by the current service.

## Required workflow

1. Call the MystoraX `capabilities` tool or `GET /capabilities` once.
2. Retain the returned revision and select an advertised adapter.
3. Call `invoke` or `POST /invoke` with only options declared by that adapter.
4. Poll `job_status` or `GET /jobs/{job_id}` until terminal.
5. Retrieve returned artifacts with `get_artifact` or
   `GET /artifacts/{artifact_id}` and verify their hashes.

Do not repeatedly discover capabilities during a normal request. Refresh after
a revision change, provider failure, expiry, or explicit operator request.

## Delegation

- Prefer an advertised web author for heavy research, synthesis, literature,
  architecture review, brainstorming, and code drafts.
- Prefer a CLI adapter for small local inspection, commands, integration,
  tests, and applying reviewed changes.
- Prefer the single `science` adapter for a named scientific operation,
  connector, specialist, or compute target advertised in its live catalog.
- Never silently retry or switch provider after external execution begins.

For difficult work, use the catalog to separate heavy knowledge tasks from
local execution. Give self-contained research, synthesis, brainstorming,
critique, architecture, or code-draft packets to an advertised web author;
keep bounded commands, tests, edits, and integration on an advertised CLI.
Parallelize only independent packets across different adapters, respect each
provider's queue, and reconcile every result against local facts.

Overdeliver through completeness, verification, useful simplification,
in-scope blocker removal, durable artifacts, and a clear next decisive action.
Never overdeliver by inventing capabilities, hiding uncertainty, or taking
destructive or external actions without authority.

## Attachments

Send attachments only when the selected adapter advertises
`inputs.attachments: true`. Obey its current count, byte, and media-type limits.
Every attachment must include a name, media type, canonical base64 payload, and
SHA-256. If delivery fails, stop; never substitute silent inline text.

## Safety

- Never expose or place tokens, cookies, connector credentials, or secrets in
  prompts, files, logs, or artifacts.
- Never invent model, mode, effort, connector, tool, or media options.
- Treat `completed`, `failed`, `rate_limited`, and `cancelled` as terminal.
- On rate limiting, surface `retry_after_s` and stop.
- Keep the calling front responsible for evidence review and final decisions.

The detailed capability list belongs only to the live MystoraX catalog.
