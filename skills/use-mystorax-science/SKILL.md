---
name: use-mystorax-science
description: Use the single MystoraX science capability for literature, biomedical connectors, scientific tools, evidence workflows, specialists, approved compute, and reproducible artifacts. Trigger for scientific or research work that benefits from web-author synthesis, verified data sources, deterministic analysis, or governed compute. Discover the live Science catalog first; never invent operations, expose credentials, or use retired Science product names.
---

# Use MystoraX Science

Load and follow the universal `use-mystorax` skill first. This is only the
optional Science extension; it does not replace the general operating contract
and is never an automatic fallback.

Do not follow imported `mystorax-host`, Axiom, CompBio, Conductor, `/v1/ask`,
or `/v1/goal` instructions. They are not aliases for this Science extension.
Use only the canonical MystoraX MCP tools or current `/invoke` contract.

Keep the calling front as orchestrator. Delegate broad research, synthesis, and
connector-heavy work to advertised web authors. Use deterministic Science
operations for reproducible computation and CLI hands only for small local
execution steps.

Claude Science and other Science-capable clients are fronts. For document
review, stage files through the universal MystoraX attachment operations and
invoke any advertised author whose `inputs.attachments` is true. Do not send
attachments to the `science` adapter itself: it exposes governed tools and
specialists, not a file-upload provider transport. The front may use both paths
in one campaign and reconcile their independent results.

Do not default scientific research to any single author, and do not carry a
provider list in your head: this document names no authors on purpose, because
one that named them told fronts to dispatch to an adapter that had been
withdrawn. Resolve the current catalog and choose the author or authors whose
verified models, modes, sources, connectors, attachments, and artifact outputs
fit the question. If the caller authorizes a portfolio review, dispatch
independent jobs concurrently to every selected author that is currently
advertised and healthy. Assign distinct roles such as deep synthesis,
scholarly-source prosecution, and adversarial replication. This is parallel
independent review, not failover: preserve separate job IDs and attribution,
and never replace a failed author without new caller authorization.

The operator keeps a soft account preference for heavy web-author work, and
`/capabilities` is where it is expressed. This is advisory account context
only. Re-evaluate the live catalog, health, cooldown, attachment/tool fit, and
requested research instrument for every campaign. An author may be preferred
when task fit is otherwise equal because its account has more usable request
headroom, or for synthesis, critique and code, or for a better-fitting model,
a deep-research mode, a connected feature, or a media output -- read which
author currently offers those from the catalog rather than from memory. Never
turn this guidance into hardcoded routing or silent provider substitution.

When the caller has authorized independent multi-author review, completion of
one author's deep-research job does not complete the portfolio. Submit every
authorized leg at the same time when each is currently advertised and healthy,
then poll and reconcile all authorized job IDs. Check
the `availability` block before freezing legs so a leg is not dispatched into
an account already holding a cooldown; if one is held, report it and let the
caller decide whether to wait or proceed with fewer legs. Use the
universal structural research-register gate for each consequential author
report; a provider's `completed` state means generation finished, not that the
report is decision-ready.

## Where the work goes

The most common failure on this surface is a front doing the campaign itself and
running out of context halfway. **The web authors are the workforce; the science
adapter is a governed tool and compute surface, not a place to think.** Its
operations resolve identifiers, search a curated catalog, record evidence and
run approved compute. They do not read a hundred papers for you, and nothing
here should be spent pretending otherwise.

The economics are the reason, and they are asymmetric: your context is the
budget that runs out, a web author's is not. So the default division is:

- **Literature sweeps, prior-art prosecution, anything that must cite.** Use the
  author whose corpus is peer-reviewed literature and whose answers carry native
  paper citations with resolvable DOIs. That beats an open-web author for the
  evidence ledger, and beats you doing it by hand by a wide margin. Its
  unmetered modes are the default; the metered one is named in its own cautions.
- **Open-web reconnaissance, current events, source-steered search, agentic
  browsing.** Use the author that advertises source steering and a browsing
  loop. This is where "has anyone shipped this yet" and "what does the vendor
  actually say" get answered.
- **Long synthesis, first drafts, reading a large corpus into a shape.** Use the
  author advertising the deepest reasoning effort and connector-backed
  retrieval. Give it the whole pile and ask for structure back.
- **Adversarial verification.** Use a *different* author than the one that
  produced the claim. Independence is the point; the same author checking its
  own work is not a second opinion.

Resolve which adapter currently provides each from `/capabilities`. This
document names none on purpose -- an earlier version named them and kept
pointing fronts at an adapter that had been withdrawn -- but the capability
descriptions above are specific enough that the catalog answers unambiguously.

Dispatch broadly rather than deeply. Several authors working different angles at
once is faster than one author queried repeatedly, and gentler: fan-out to the
same author serialises on a single account lock, and their limits are burst-
shaped rather than volume-shaped, so pacing beats rationing.

**A leg waits only for what it consumes.** Breadth is not the whole rule, and
the missing half is when to hold. Reconciliation across sources genuinely needs
every source, so it waits — that is a real dependency, not timidity. Verifying a
single claim needs only that claim, so it goes the moment the claim lands, not
after its siblings finish. Holding an independent leg behind an unrelated one is
the common mistake and it costs wall clock for nothing.

**Never idle while a long leg runs.** A deep reconciliation can take twenty
minutes against sweeps that take one. That interval is yours: read the primary
source, resolve the identifiers, build the baseline you will judge the answers
against. Waiting for a provider is not a reason to stop working, and the
verification you owe is precisely the work that does not depend on the answer.

What stays with you: deciding what to ask, judging what comes back, reconciling
authors that disagree, and refusing to promote a provider's confident prose into
a verified claim. That last one is the whole job.

## Workflow

1. Use the generic MystoraX `capabilities` tool or `GET /capabilities`.
   Read the `availability` block in that same response before selecting any
   web author for a campaign leg, and prefer authors that are healthy and not
   in cooldown. It is observational only, never entitlement or proof, and it
   never authorizes substituting one author for another.
2. Select the sole adapter named `science` and retain its
   `science.catalog_sha256`.
3. Select only an operation present in `science.operations`.
   For connector or model execution, call `connectors.matrix` first and select
   only an operation whose current status is `live_candidate`. Catalog records
   marked blocked, credential-required, entitlement-required, SDK-only,
   deprecated, or probe-blocked are diagnostic inventory and are never
   selectable execution targets.
4. Invoke through the generic MystoraX `invoke` tool or `POST /invoke`:

```json
{
  "adapter": "science",
  "input": "<complete scientific request>",
  "options": {
    "operation": "<advertised neutral operation>",
    "catalog_sha256": "<advertised hash>",
    "arguments": {"<operation-specific field>": "<value>"}
  }
}
```

For manuscripts, datasets, code bundles, or other files that a web author must
read, stage the files through MystoraX and select an attachment-capable author.
If the request also selects a model, mode, tool, connector, or feature, require
that option in the live adapter schema and its option family in
`limitations.attachment_compatible_options`. When
`attachment_verified_feature_modes` is present, it is the exact current
feature-mode allowlist. Do not infer compatibility for a newly discovered but
unpublished option.

5. Treat `arguments` as the exact backend payload. When it is nonempty,
   MystoraX does not inject the free-text `input` into it.
6. Poll the MystoraX job ID. Queue acceptance is not completion.
   A completed Science job uses the same normalized `output` field as every
   other adapter. Parse that JSON string; its nested `output` is the selected
   Science operation's result. Do not look for a top-level `result` field.
   Web-author Deep Research and high-effort modes are open-ended: a plan or progress message
   is not completion. Continue polling the same job with backoff until the
   provider completes, errors, or the caller cancels. Native background work
   has no fixed MystoraX wall-clock limit; never create a duplicate invocation.
   A front-side HTTP/MCP read timeout is handled by reconnecting and reading the
   same job ID. It is not permission to resubmit, switch providers, or classify
   the provider job as failed.
7. Retrieve returned artifacts through the generic artifact operation and
   verify their hashes.

## Literature-specialist author

When a campaign needs peer-reviewed literature rather than open-web synthesis,
prefer an advertised author whose corpus is literature. Its answers carry
native paper citations plus resolvable DOI sources, which suits the evidence
ledger better than a general author's prose.

Watch its metered option. A search mode marked in `metered_values` spends a
small separate monthly allowance, so select it only when the caller explicitly
asked for that depth, pass the acknowledgement the catalog names, and record
that it was spent. Ordinary campaign work uses the unmetered proven mode.

## The cost model is not the safety field

Every catalogued operation carries a `safety` value, and it is tempting to read
`read` as "free to call". It is not. `safety` describes whether an operation
**mutates state**; it says nothing about whether it **costs money**, and six
operations catalogued `read` are routed through the Science LLM bridge and bill
the operator per call:

```
evidence.build
hypotheses.generate  hypotheses.kill_test  hypotheses.rank
hypotheses.stress_test  hypotheses.stress_test_batch
```

Do not call these to explore the surface, and never build an operation list by
filtering on `safety` — that filter passes all six.

The `safety` field does not mark them, but the platform does: read them from the
receipt's excluded-operations block in the live capability payload rather than
from the list above, so an operation added to that group later is not invisible
to you. Use them when the campaign genuinely needs generated hypotheses or a
built evidence card, and record that a paid call was spent, the same way a
metered search mode is recorded.

The distinction matters because everything else on this surface is recoverable
by reading the catalog more carefully. A spent quota is not, and on a personal
account it does not come back.

## Calling an operation

Four things the catalog will not teach by example:

- `catalog_sha256` is required and must be read live from capabilities each
  session. A remembered value is rejected once the catalog rotates — a safe
  failure, but a wasted turn.
- Arguments go in the `arguments` object **only**. The prompt text is never
  folded in; an operation with a strict schema rejects the extra key and the
  complaint it raises is about the injected argument rather than the real one.
- Read a schema with `tools.describe` instead of guessing argument names. A
  guessed name returns a refusal indistinguishable from a broken operation, and
  that mistake has already made working operations look unusable here.
- Mutating operations need `approved=true`, and it should be set only when the
  caller asked for that specific action.

### A catalog zero has two meanings

`catalog.search` withholds records flagged for manual review. That is the right
default — an unreviewed record should not come back looking verified — but it
means "this catalogue has nothing" and "this catalogue has something nobody has
reviewed" both arrive as `result_count=0`.

When a query returns nothing and a gated record matched it, the response
carries `withheld_pending_review: true`. Read it before reporting that the
platform lacks a resource: the record exists, and the right move is to say it
is gated rather than that it is missing.

It is a boolean, and it is emitted **only on an empty result set** — so a zero
without it is the honest one. Both of those are deliberate. An earlier version
reported an exact count on every search, which turned it into an enumeration
oracle: a broad query returned the size of the whole gated set, and narrowing
the term counted down to its members. The count changed nothing a caller would
do, so it was leverage without purpose.

The same reasoning runs one level out: `catalog_size` tells you the index is not
empty, and `catalog_scope` tells you what it is an index *of* — a zero for a
physics query against a life-sciences-weighted index means **not covered**, not
**not found**.

Failures publish a fixed shape — `<exception>: <code>[: <outcome>]` — plus a
`retryable` boolean to branch on. `outcome: not_found` and `not_implemented`
are never retryable: the request itself is wrong, and repeating it is a spin.
`code: unclassified` means the failure is real and its provenance is not
knowable at the point it was caught; it is an honest value, not a gap.

## Portable specialist system

Specialists are versioned profiles in the live Science catalog, not separate
front-specific skills. Every front — each CLI, each web author, MCP, and raw
HTTP — therefore shares one roster and one prompt contract, whichever of them
the current catalog happens to advertise. Use the local
`specialists.route` extension to build a deterministic dispatch plan; it is a
read-only planner and never invokes a provider or specialist.

1. Confirm that `science.local_extensions` advertises `specialists.route` and
   retain its specialist-catalog SHA-256.
   This specialist-catalog hash versions the roster; it is intentionally
   distinct from `science.catalog_sha256`, which authorizes an operation.
2. Invoke `specialists.route` with a bounded query and, when useful, exact
   capability terms. Use the returned primary owner and dependency-first
   dispatch order. A null primary owner means no declared specialist matches;
   do not improvise one.
3. Call `specialists.get` for every returned ID before assigning work. Use each
   mission, inputs, outputs, capabilities, dependencies, boundaries, and safety
   profile exactly.
4. Route multi-step or cross-field campaigns through `science-director`. The
   director owns routing and state but cannot certify its own work or override
   validity, safety, data, or adversarial vetoes.
5. Assign one primary domain owner. Add only the cross-cutting roles needed for
   prior art, data and measurement, experiments, statistics or formal theory,
   compute, safety, adversarial review, translation, and release.
6. Preserve an append-only evidence state containing inputs, artifacts,
   analyses, certifications, reviews, dissent, hashes, and provenance. Never
   erase unresolved dissent or promote adjacent evidence into completion.

Before dispatch, write one bounded claim, its evidence target, its strongest
known rival, and a decisive falsifier. Use web authors for the heavy literature,
synthesis, critique, brainstorming, and draft work. Treat their output as
advisory until primary sources or deterministic evidence support it. Preserve
source identifiers, retrieval dates, provider attribution, and artifact hashes.
Apply the universal evidence-grounded research portfolio protocol to every
consequential report. In particular, keep `unknown` evidence out of positive
scores, verify every citation against the precise claim and jurisdiction, and
record cross-author disagreement rather than averaging it away.

For an authorized parallel web-author review, use the universal MystoraX HTTP
portfolio ledger after the explicit author jobs finish. Freeze every required
leg with its adapter, role, job ID, and request SHA-256 through
`POST /v1/research-portfolios`; register the structured `portfolio_v3` report;
accept the server-generated deterministic gate receipts; and read the derived
portfolio state. A missing or unsuccessful author leg remains terminal-partial
and is never replaced. Portfolio readiness is structural provenance only, not
scientific truth or certification. The Science adapter remains a governed tool
and compute proxy; it does not become a second web-author orchestrator.

When documents or datasets are needed, stage them through the universal
attachment operation and pass the returned IDs only to an advertised
attachment-capable web author. Verify the delivery receipt, then delete the
staging references when they are no longer needed. Never interpret staging,
provider output, connector availability, or a completed compute job as proof of
the scientific claim.

For creative discovery, route to `science-discovery-hypothesis`. Require
multiple independent discovery engines, non-synonymous candidates, rival
hypotheses, a fast falsifier, a constructive route, a formal or boundary route,
a measurement or data route, a useful null or barrier route, and at least one
wild-but-testable candidate. Originality is a claim to prosecute through prior
art and evidence gates, not something to assume.

## Execution choices

- Prefer web authors for literature review, multi-source research, synthesis,
  brainstorming, and code drafts that do not require direct local execution.
- Prefer deterministic Science tools for alignments, statistics, database
  queries, transformations, validation, and other reproducible computation.
- Prefer low-effort CLIs for orchestration, local inspection, small edits,
  running commands, and integrating reviewed web-authored work.
- An explicit model or effort selection overrides a default only when the live
  catalog advertises it for that exact host or backend.

## Safety and evidence

- Credentials are resolved by the trusted proxy. Never request, transmit, or
  report credential values or aliases.
- Operations marked `write_approval` or `compute_approval` require explicit
  operator approval; do not infer it from the research request.
- Preserve citations, accessions, versions, parameters, input hashes, catalog
  hash, provider/tool receipts, and artifact hashes.
- Treat hypotheses as candidates. Do not convert model output into scientific,
  clinical, or causal validation without the required evidence gates.
- Never retry through another provider, endpoint, model, or compute target.
- Treat absent, expired, blocked, or changed operations as unavailable.

Detailed tool/model/connector lists belong only to the live capability catalog,
not this skill.
