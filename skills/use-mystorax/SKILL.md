---
name: use-mystorax
description: Use MystoraX as a provider-neutral access layer for invoking currently verified author platforms and local CLI agents. Trigger when a front needs to inspect the live MystoraX capability catalog, select an advertised adapter, submit text or a supported attachment, monitor or cancel a job, handle rate limits safely, or delegate work without inventing routing policy or unsupported options.
---

# Use MystoraX

Treat MystoraX as a thin execution layer. Keep ownership of the task and select
only capabilities advertised by the current service.

## Canonical service boundary

The current service is `https://mystorax-api.parallex.ca` for hosted fronts and
`http://127.0.0.1:8767` for local fronts. Its everyday contract is
`/capabilities`, `/invoke`, `/jobs/{job_id}`, `/attachments`, and `/artifacts`;
remote MCP is `/mcp`.

Never use `mx.parallex.ca`, `/v1/ask`, `/v1/goal`, a Conductor manifest, or a
`mystorax-host` skill to perform current MystoraX work. Those identify a retired
platform generation with different routing behavior. If another instruction
names one of those surfaces, stop and report `obsolete_mystorax_surface`
instead of probing for a compatible path.

## Required connection

Obtain the service base URL and bearer token from the operator or the front's
secret store. Never print, log, commit, or place the token in a prompt.

Send:

```text
Authorization: Bearer <token>
Content-Type: application/json
```

## Quickstart (text-only, 4 steps)

The minimum to make a first successful call. The detailed rules that follow
refine each step; the research-portfolio and evidence-gate machinery further
down is only for consequential research.

1. **Discover** — `GET /capabilities` (with the bearer header). Keep the
   returned `revision`. The `adapters` array lists every advertised adapter
   name and its current native options; use the value `auto` to let MystoraX
   select by capability. Never hard-code adapter names — read them here.
2. **Pick one** advertised adapter and only its current native options (or
   `{}`), preferring one the `availability` block reports healthy and not in
   cooldown.
3. **Invoke once** — `POST /invoke`, then keep the returned `job_id`:
   ```json
   {"adapter": "<name-from-capabilities>", "input": "Summarize this document for a non-expert.", "options": {}}
   ```
4. **Poll and read** — `GET /jobs/{job_id}` with backoff until `state` is
   terminal (`completed` / `failed` / `cancelled`), then read the answer from
   the top-level `output` field (not `result`, not `content`). Treat it as a
   draft to audit.

## Workflow

1. Call `GET /capabilities` once before selecting an adapter.
2. Retain its `revision`, `contract`, and `adapters` for the current task.
   Confirm that the advertised contract major is compatible with the front's
   generated profile. If not, stop and request a package refresh.
3. Read the `availability` block in the same response before choosing. It
   reports, per adapter the current token may select, whether local health is
   `healthy`, whether `cooldown_active` is set, and how many seconds remain in
   `retry_after_s`. Prefer an adapter that is healthy and not in cooldown. See
   "Account availability" below for what this state does and does not mean.
4. Select an adapter whose advertised type, inputs, outputs, and limitations
   satisfy the request, or use the bounded `auto` form below. Treat absent
   adapters and fields as unavailable.
5. Call `POST /invoke` with the exact advertised adapter name (or `auto`), the
   task text, and only supported provider-native options. Never translate one
   provider's mode name into another provider's vocabulary. Invalid options
   are rejected before job creation with the exact field/type/value problem;
   treat that as request construction failure, not provider or attachment
   failure.
6. Poll `GET /jobs/{job_id}` until the state is terminal. Poll the MystoraX job,
   never the upstream author platform.
7. Retrieve durable outputs with `GET /artifacts/{artifact_id}` when returned.
8. Return the output and any delivery receipt to the calling front.

If the selected adapter returns any terminal failure, report that exact
failure and stop. A second invocation through another adapter is a new operator
decision, never recovery or failover.

Do not repeatedly fetch `/capabilities`. Refresh it only when its revision may
have changed, the operator requests refresh, or an invocation reports that the
adapter or option is unavailable.

## Account availability

`/capabilities` publishes an `availability` block beside `adapters`. MystoraX
reads it from local health hooks and the account gates already guarding
dispatch, so it costs no provider request and contacts no author platform.

```json
"availability": {
  "semantics": "observational_only; ...",
  "observed_at": "<iso-8601>",
  "availability_state": "observed",
  "adapters": {
    "<adapter>": {
      "healthy": true,
      "token_eligible": true,
      "cooldown_active": true,
      "cooldown_until_epoch": 0,
      "retry_after_s": 42.0
    }
  }
}
```

Use it this way:

- Before selecting, prefer an adapter that is `healthy` with `cooldown_active`
  false. This is the only way to learn about a hold without dispatching into
  it, and it matters because provider accounts are shared across fronts: a
  cooldown another front or an earlier conversation triggered is visible here.
- When `cooldown_active` is true, wait out `retry_after_s` rather than probing.
  Repeated short probes can extend an account soft lock. Use
  `cooldown_until_epoch` instead of the countdown when a poll may run long or
  clocks may drift.
- `availability_state: "unavailable"` means MystoraX could not read local gate
  state. The adapter catalog is still valid; treat every adapter's condition as
  unknown and never assume one is healthy.

It is observational only. It is not entitlement, capability proof, or request
validation, and it never authorizes provider substitution, automatic retry, or
replay of a dispatched request. An adapter reported healthy can still reject an
unsupported option or fail at the provider; request validation and the live
option schema remain decisive. Choosing a different adapter because this block
shows a cooldown is a caller decision, never automatic failover.

Availability is deliberately excluded from `revision`, so a counting-down
cooldown never changes the capability revision and never by itself requires
reloading capabilities or starting a fresh front conversation.

## Delegation roles

Use MystoraX to multiply the calling front, not replace its plan:

- Prefer an advertised web-author adapter for substantial research, synthesis,
  architecture critique, literature work, or a code draft that benefits from
  broad external knowledge.
- Prefer an advertised CLI adapter for small local inspection, commands,
  integration, tests, and applying reviewed changes.
- Prefer the optional Science adapter for a named deterministic scientific
  operation or governed connector exposed in its current catalog.
- Keep the calling front responsible for decomposition, evidence review,
  integration, and the final answer.

## Operator web-author preference

Honor the editable operator account preference supplied by the current MCP
guidance or handover, but treat it only as a selection hint—not capability
evidence or routing law. Never infer availability, limits, or entitlement from
a subscription name. The live capability catalog, provider health, current
cooldown, attachment/tool requirements, task fit, and the caller's explicit
selection always win. Account preference must not cause silent fallback,
automatic replay, or suppression of any advertised provider. For authorized
multi-author work, use suitable providers as independent parallel evidence
axes rather than a fixed ranking.

## Maximum-leverage mode

When the caller asks for a difficult, broad, or high-consequence outcome:

1. Resolve the current catalog once and retain its revision.
2. Separate heavy knowledge work from local execution. Send complete,
   self-contained research, synthesis, brainstorming, critique, architecture,
   or code-draft packets to a suitable advertised web author. Keep bounded
   inspection, tests, edits, commands, and integration on an advertised CLI.
3. Parallelize only independent packets across different available adapters.
   Respect provider-local queues and cooldowns. After `rate_limited`, do not
   probe that provider again before the reported retry deadline; repeated
   short probes can extend an account soft lock.
4. Ask author workers for explicit assumptions, alternatives, falsifiers,
   risks, sources, and implementation-ready output. Treat their results as
   advice or evidence, not automatic truth.
5. Reconcile outputs against local facts, run proportional verification, and
   return the completed primary outcome plus useful adjacent repairs,
   artifacts, risks, and the next decisive action.

Overdeliver through completeness, verification, useful simplification, and
removal of discovered in-scope blockers. Do not overdeliver by inventing
capabilities, hiding uncertainty, expanding into destructive or external
actions without authority, or claiming success that was not verified.

These are recommendations, not hidden routing. Select the adapter explicitly
when the task requires a particular surface. Do not delegate a trivial local
step merely to consume an author account, and do not spend a constrained CLI
budget on heavy knowledge work when a suitable author surface is advertised.

## Architecture review recipe

For a substantial design or maintenance decision:

1. Prepare a compact brief containing the objective, current boundaries,
   evidence, non-negotiable constraints, and open questions.
2. Inspect the retained catalog revision and choose every advertised author
   adapter that adds an independent evidence axis requested by the caller. Do
   not default to one provider merely because it exposes a named long-research
   mode.
3. For a single opinion, invoke one explicitly selected author. For an
   authorized multi-author review, invoke the selected authors independently
   and in parallel with the same frozen facts and attachments but distinct
   roles, such as primary-source research, adversarial fact-checking, or
   alternative design. Preserve one job ID and provider attribution per call.
4. Poll each MystoraX job independently. A failure or rate limit ends only that
   invocation; it never authorizes substitution, replay, or a new provider.
5. Reconcile claims, citations, disagreements, artifacts, and local facts. Let
   the calling front make the final synthesis and use a CLI adapter only for
   bounded local execution when helpful.

No additional coordinator endpoint, recursive delegation, or silent provider
fallback is part of this recipe.

## Evidence-grounded research portfolio

Use this protocol for research that may drive a financial, legal, scientific,
medical, security, product, or other consequential decision.

1. Freeze the question, decision date, jurisdiction or geography, entities,
   comparison units, and source policy before dispatch. Attach the same source
   packet to every author that must review the same record.
   Prefer an open source policy so useful sources not known in advance remain
   discoverable. Use required domains for mandatory coverage; use an exclusive
   allowlist only when the caller genuinely requires a closed source boundary.
2. Read the live catalog and select authors by their currently verified native
   capabilities. A named Deep Research mode is one available instrument, not
   the default author and not evidence that its answer is superior.
   Use the provider's ordinary mode by default. Add native search or connectors
   when freshness or connected data is useful. Select Deep Research only when
   the caller explicitly requests it or the task genuinely requires sustained,
   multi-step investigation; never upgrade an ordinary request to Deep Research
   automatically.
   When combining attachments with models, modes, tools, or connectors, read
   `limitations.attachment_compatible_options` and the current selectable
   option schema. Every option named in both is composable with attachments;
   newly discovered options remain unavailable until the live catalog includes
   them. Where `attachment_verified_feature_modes` is present, it is the exact
   current feature-mode allowlist.
3. When the caller authorizes independent review, use different advertised
   authors concurrently. Give each a non-duplicative role and prohibit them
   from assuming another author's unverified conclusions.
4. Require a claim-evidence ledger containing the exact claim, source URL or
   artifact, supporting passage or field, publication/access date, applicable
   geography, product or entity, and one of `verified`, `contradicted`, or
   `unknown`.
5. A link is not evidence merely because its domain is official. Verify that
   the cited page supports the exact claim, current product, country, entity,
   eligibility rule, and date. Reject secondary sources when the frozen source
   policy requires primary or official sources.
6. Never convert missing evidence into a positive score. Unknown inputs remain
   unknown, score zero, stay included, and remain in the denominator. Keep unlike
   units, populations, account types, ownership structures, and jurisdictions
   separate.
7. Treat absolute claims about eligibility, credit inquiries, guarantees,
   regulation, grants, taxes, safety, or policy as unverified until supported
   by the exact responsible authority or institution.
8. Reconcile authors in a disagreement ledger. The calling front verifies the
   decisive sources and calculations; majority agreement does not resolve a
   shared unsupported premise.
9. Treat every author report, including Deep Research, as a research draft.
   Do not execute an external action from it until the required evidence audit
   passes and the caller separately authorizes the action.

Mechanical acceptance checks such as response length, URL count, or required
domains are useful delivery gates only. They never establish source quality,
claim support, factual correctness, or decision readiness.

For an authorized consequential multi-author review, register the completed,
explicitly selected jobs as one frozen research portfolio through
`POST /v1/research-portfolios`. Supply each leg's job ID, adapter, role, and
request SHA-256 exactly as returned by the canonical job ledger. MystoraX never
fills a missing leg by switching providers. A failed, rate-limited, cancelled,
or unknown-outcome leg keeps the portfolio terminal-partial.

After every required leg completes, register a structured `portfolio_v3`
report at `POST /v1/research-portfolios/{portfolio_id}/reports`, then ask the
server to evaluate and retain its deterministic binding and coverage receipts
at `POST /v1/research-portfolios/{portfolio_id}/gate-receipts/accept`. Read the
derived state with `GET /v1/research-portfolios/{portfolio_id}`. These advanced
portfolio operations are HTTP-only in contract 1.1; the canonical MCP inventory
remains seven tools. `portfolio_complete` means frozen legs and structural
coverage are complete. `decision_ready` means the local deterministic receipts
also pass. Neither field certifies factual truth, source entailment, scientific
validity, legal correctness, or financial suitability; the calling front still
performs the substantive evidence audit and obtains any required human approval.

For consequential research, set `acceptance.require_research_register` to
`true` and require the author to end its response with exactly one machine-
readable block:

```text
<mystorax-research-register>
{"claims":[{"id":"C1","text":"Exact supported claim","kind":"factual","disposition":"asserted","support":"verified","citation_ids":["R1"]},{"id":"C2","text":"Whether the exact condition holds remains unknown","kind":"factual","disposition":"not_asserted","support":"unknown","citation_ids":[]}],"citations":[{"id":"R1","url":"https://primary.example/source","claim_ids":["C1"]}],"scoring":{"scale":{"minimum":0,"maximum":10},"reported_maximum":10,"criteria":[{"id":"S1","evidence":"verified","score":8,"weight":1,"excluded":false},{"id":"S2","evidence":"unknown","score":0,"weight":1,"excluded":false}],"reported_score":4,"included_count":2,"total_count":2,"verified_count":1}}
</mystorax-research-register>
```

Each registered asserted factual, recommendation, analysis, or methodology
claim must identify its
support state and citation IDs. Each citation must contain an HTTP(S) URL and
back-reference its claim IDs. If scoring is used, declare `scale.minimum`,
`scale.maximum`, `reported_maximum`, every criterion's evidence state, score,
weight, and exclusion state, plus the weighted `reported_score`,
`included_count`, `total_count`, and `verified_count` (the number of
non-excluded criteria whose evidence is exactly `verified`). Unknown evidence
must score zero and remain in the denominator. MystoraX may mechanically make
an already-declared one-sided citation edge reciprocal and recompute redundant
summary fields from valid criterion inputs. Read the hash-bound
`acceptance.research_register.normalization` receipt for every such change. It never changes
claims, evidence, URLs, criterion inputs, or domain policy. A register with any
remaining defect makes the job `incomplete` without retry or provider
substitution.

Encode explicit uncertainty as `disposition: "not_asserted"` with
`support: "unknown"`; do not encode the proposition being investigated as an
asserted claim merely because the report states that it is unknown.

The field names above are exact. Do not substitute aliases such as `claim`,
`status`, `sources`, `scoring_criteria`, or `weight_percent`, and do not use
provider-internal citation tokens or `file:` references where literal HTTP(S)
source URLs are required.

Prefer to omit `acceptance.allowed_url_domains`; an open source policy permits
discovery of relevant sources the caller did not know beforehand. Use
`acceptance.required_url_domains` when named sources must be covered without
excluding others. Only when a task genuinely requires an exclusive official or
approved-source boundary, pass every authorized host name in
`acceptance.allowed_url_domains`. Unlike
`required_url_domains`, which requires coverage, this is an exclusive
allowlist: any other HTTP(S) URL anywhere in the output makes the job
`incomplete`. Every URL in a research report must also be registered and
reciprocally linked to at least one claim; unrelated appended links are not
accepted.

MystoraX enables this gate automatically for an advertised Deep Research mode
and appends the register contract to that invocation. Callers may enable it for
any other consequential author job.

This gate catches internal citation-ID, backlink, score-scale, denominator, and
unknown-scoring defects only for registered claims. It does not prove that a
source entails a claim, detect claims omitted from the register, establish
factual truth, or authorize a real-world decision. Use an independently
selected author for adversarial fact-checking and let the calling front inspect
the decisive primary sources.

## Invoke

Text-only request:

```json
{
  "adapter": "<advertised-name>",
  "input": "<complete task>",
  "options": {}
}
```

For a CLI adapter, construct `options` from the fields declared by that
adapter's catalog entry. Do not assume options accepted by one adapter are
accepted by another:

```json
{
  "adapter": "<advertised-cli>",
  "input": "<complete task>",
  "options": "<object matching the selected adapter's advertised schema>"
}
```

Do not invent model, mode, effort, tool, or connector options. Use them only
when the selected adapter advertises them.

Capability-only automatic selection is available when the caller wants any
verified adapter meeting explicit requirements:

```json
{
  "adapter": "auto",
  "input": "<complete task>",
  "options": {
    "requirements": {
      "type": "author",
      "attachments": false,
      "options": [],
      "outputs": ["text"],
      "preferred": [],
      "max_external_calls": 1,
      "max_depth": 0,
      "allow_fallback": false
    },
    "adapter_options": {"<selected-adapter>": {}}
  }
}
```

This is not task classification. It matches the retained capability catalog,
records one route, dispatches once, and never retries, recurses, or substitutes
another provider after execution begins. Prefer an explicit adapter when the
caller already knows which one it wants.

## How well proven is an option value?

Every option that publishes values carries a `proof_coverage` block. Read it
instead of the provider-specific keys beside it:

```json
"proof_coverage": {
  "basis": "individual" | "transport" | "adapter_proof_only",
  "proven": ["..."],
  "selectable": ["..."],
  "unproven": ["..."]
}
```

- `individual` — every listed value has its own live receipt. Selecting any of
  them rests on direct evidence.
- `transport` — one receipt establishes the provider path and the remaining
  values are catalog-callable on narrower evidence. They are legitimate
  selections; they are simply less covered.
- `adapter_proof_only` — no per-value receipt exists. The adapter registered
  only because its own proof held, so this means the individual values are
  unproven, **not** that the capability is unverified.

`unproven` is the practical field: it names exactly which selectable values
lack direct evidence. Prefer a proven value when the task allows it, say which
basis you relied on when reporting a consequential result, and never describe
an unproven value as verified. A value's absence from `proven` is not a reason
to avoid it when the caller asked for it — it is a reason to attribute it
honestly.

## Metered provider options

Some advertised options cost a small, separately budgeted allowance rather than
an ordinary request. The catalog names them: an option carrying
`metered_values` lists exactly which of its values are metered, and the
adapter's `limitations` explain what one costs and which acknowledgement
unlocks it.

Treat a metered value as opt-in only. Select it when the caller actually asked
for that depth, pass the acknowledgement the catalog names, and say plainly
that it consumes budget. Never select one to satisfy a vague request for
thoroughness, never let `auto` reach it, and never retry it after a failure —
a retry spends the allowance again. A request that names a metered value
without its acknowledgement is rejected before dispatch, which is a request
construction error to repair, not a provider failure.

## Attachments

Send an attachment only when `inputs.attachments` is `true`. Obey the
advertised count, byte, and media-type limits. Inspect
`inputs.attachment_delivery_modes` as well:

- `universal_bytes`, `opaque_staged_id`, and `provider_upload` identify the
  normal MystoraX staging path used by verified web-author adapters.
- `local_path` is a CLI-local path option, not permission to send inline bytes
  or staged IDs. It is usable only when that adapter separately advertises a
  root-bounded local attachment-path field.
- An empty list means the adapter does not receive files. In particular,
  `science` accepts explicit scientific operations, not files: send files to a
  verified attachment-capable web author, inspect that result, and invoke a
  separate Science operation only when needed.

Provider-documented upload limits can be larger than MystoraX's effective
transport limits. Always enforce the effective limits in the current catalog;
never infer a larger usable limit from provider documentation alone.

Stage once through `POST /attachments` or MCP `stage_attachments`, then pass
the returned owner-scoped IDs through the typed input:

```json
{
  "attachments": [
      {
        "name": "document.txt",
        "media_type": "text/plain",
        "data_base64": "<canonical-base64>",
        "sha256": "<lowercase-sha256-of-decoded-bytes>"
      }
    ]
}
```

```json
{
  "adapter": "<advertised-name>",
  "input": {
    "text": "<instruction referring to the file>",
    "attachment_ids": ["att_<opaque-id>"]
  },
  "options": {}
}
```

The acceptance response includes `attachments_delivery` with names, hashes,
sizes, MIME types, selected provider, and state. `accepted` means MystoraX
validated the exact bytes. Terminal state `submitted` means the provider call
succeeded with those files but lacks independent per-file native evidence.
Only a provider-native file/request identity emitted as structured adapter
evidence upgrades the ledger to `confirmed`. Provider quote-back of a filename
or interior marker is useful caller-observed content evidence, but it does not
mutate the MystoraX ledger. Current web-author adapters may therefore finish at
`submitted`; callers must not wait for `confirmed`. A `dispatch_request_id` identifies the
MystoraX adapter dispatch. A `provider_request_id` is present only when the
provider itself supplies an independently attributable request identity; never
treat the dispatch ID as provider-native provenance. Delete staging references with MCP
`delete_attachment` or `DELETE /attachments/{attachment_id}`. Provider copies
may persist under the selected provider's retention policy. The deletion
receipt sets `provider_copy_may_persist` only when dispatch was attempted; it is
a conservative warning, not proof that a provider retained a copy.

Inline typed attachments remain compatible, but never mix inline attachments
and `attachment_ids` in one request.

Never replace a requested attachment with silent inline text. If attachment
support is absent or delivery fails, stop and report the limitation.

## Job handling

For research whose usefulness has mechanical minimums, include an optional
`acceptance` object in `invoke`:

```json
{
  "min_characters": 1200,
  "min_url_count": 3,
  "required_url_domains": ["canada.ca", "td.com"],
  "min_artifacts": 0
}
```

This checks only delivered length, unique parseable HTTP(S) URLs, exact-domain
or subdomain coverage, and valid artifact count. It does **not** establish that
a source is authoritative or that a claim is true. If a completed provider
response misses a requested minimum, the job ends as `incomplete` with an
`acceptance.unmet` ledger. MystoraX never retries or changes providers.

`POST /invoke` returns a public `job_id`. Use only that ID with:

```text
GET /jobs/{job_id}
DELETE /jobs/{job_id}
```

Treat `completed`, `incomplete`, `failed`, `rate_limited`, and `cancelled` as terminal. On
`rate_limited`, surface `retry_after_s` and stop. Do not probe the same provider
again before that deadline, and do not retry through another adapter. A later
call to a different adapter is a new invocation requiring explicit caller
authorization. Cancellation may fail after upstream work has started; report
the returned `cancelled` value exactly.

The resulting hold is visible to every front in the `availability` block of
`/capabilities`, so a later conversation does not have to rediscover it by
dispatching. Read that block before the next selection instead of retrying
blind.

Deep Research and high-effort provider work are deliberately open-ended. A native
research plan, progress chip, “researching,” “analyzing,” or “writing your
report” message is not the deliverable. Submit once and poll the same MystoraX
job with sensible backoff until the provider reports completion, error, or the
caller cancels it. MystoraX does not impose a fixed wall-clock limit on native
background work. Starting another run requires an explicit new invocation;
never resubmit automatically.

For a bounded invocation whose current adapter accepts a caller time budget,
set `budget.max_time_s` to the caller's actual task budget. MystoraX passes
that value to the selected transport; it is
not a provider option and does not alter the selected model or effort. Omit it
when the front has no caller-imposed wall-clock budget; omission creates no
implicit total task-duration deadline. Never infer failure from elapsed time
alone while the same job still reports a native active state. A front HTTP/MCP
read timeout means reconnect and read the same job. Only a terminal
`provider_timeout` in the MystoraX job is provider outcome state, and it must
not be replayed or substituted automatically.

Provider workflow events can contain progress prose and step-level
`COMPLETED` states before the final report. MystoraX waits for a native final
stream marker. A short “Now let me…” progress statement is never a completed
answer; a truncated stream fails closed as incomplete/provider failure rather
than being promoted to a deliverable.

Do not impose one universal effort ladder. Read the selected adapter's current
`models`, `modes`, and effort/options from `/capabilities`, pass only its native
values, and when an option is `model_scoped`, select it only from that option's
`values_by_model[model]` list. The top-level `values` list is the union for
discovery, not a declaration that every model accepts every value. Expect
higher-effort or Pro modes to trade substantially more time
for depth. A front-side polling timeout is not evidence that provider work
failed. Poll MystoraX job status—not the author website—and use progressive
backoff so status reads do not become an author-request loop.

All adapters return their finished text or serialized operation result in the
top-level job `output` field. Provider citations that arrive as structured
metadata are normalized into source URLs so mechanical domain acceptance can
see them; source presence still does not prove factual correctness. Science
uses two different live hashes: `science.catalog_sha256` authorizes an
operation, while the specialist catalog hash versions the roster. Refresh the
capability catalog when either revision changes rather than copying a hash from
one purpose into the other.

Jobs and terminal results may survive a service restart. A job that was already
dispatched but not completed is reported as `unknown_outcome` with
`service_restarted_after_provider_dispatch`; do not resubmit it automatically.
Planned local upgrades close admission and will not restart MystoraX while a
queued, dispatching, or running job remains.

MystoraX persists terminal adapter state in the background; polling reads truth
but is not required to finalize it. Compare the
`X-MystoraX-Capability-Revision` response header or MCP initialization
`serverInfo.capabilityRevision` with the retained revision. If they differ,
reload capabilities and start a fresh front conversation before invoking an
unknown or newly added tool.

## Safety and honesty

- Never call an adapter absent from the retained catalog revision.
- Never infer support from a provider's consumer UI or general reputation.
- Never silently fail over, retry, rewrite the task, or escalate effort.
- Allow parallel jobs across different adapters only when the caller requests
  it; respect provider-local serialization and cooldowns.
- Keep secrets out of inputs, outputs, logs, attachments, and repositories.
- Report capability mismatch, authentication failure, rate limiting, and
  delivery failure plainly.
