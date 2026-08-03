---
name: use-mystorax-science
description: Use the single MystoraX Science capability for literature, biomedical connectors, scientific tools, evidence workflows, specialists, approved compute, and reproducible artifacts. Trigger for scientific or research work that benefits from web-author synthesis, verified data sources, deterministic analysis, or governed compute. Discover the live Science catalog first; never invent operations, expose credentials, or use retired Science product names.
---

# Use MystoraX Science

Load `use-mystorax` first. This is the only public Science extension; Axiom,
CompBio, and Science OS are retired product labels, not separate front skills.

## Workflow

1. Call MystoraX `capabilities` and select the adapter named `science`.
2. Retain `science.catalog_sha256`.
3. Select only an operation present in `science.operations`.
4. For connectors or scientific models, inspect `connectors.matrix` first and
   use only a current executable target.
5. Invoke the generic MystoraX `invoke` tool with adapter `science`, the exact
   catalog hash, operation, and operation-specific arguments.
6. Poll the MystoraX job and verify all returned artifact hashes.

## Portable specialists

The specialist system is part of the live Science catalog, not a collection of
duplicated front-specific skills.

1. Call `specialists.list` and retain its catalog version and SHA-256.
2. Call `specialists.get` with the advertised specialist ID before dispatch.
3. Use `science-director` for cross-field or multi-step campaigns. It owns
   routing and state, never scientific certification, and cannot waive data,
   validity, safety, or adversarial vetoes.
4. Assign one primary domain owner and only necessary cross-cutting reviewers.
5. Preserve append-only evidence, artifacts, certifications, reviews, dissent,
   hashes, and provenance.

Use `science-discovery-hypothesis` for intelligent, original brainstorming.
Require multiple discovery engines, rival hypotheses, decisive falsifiers,
constructive and formal routes, new observables or measurements, useful nulls
or barriers, and a wild-but-testable candidate. Treat novelty as a claim that
must survive prior-art and evidence gates.

## Execution choices

- Use web authors for heavy literature review, multi-source research,
  synthesis, brainstorming, and code drafts.
- Use deterministic Science tools for reproducible computation, databases,
  transformations, statistics, and validation.
- Use low-effort CLIs for orchestration and small local execution steps.

## Safety and evidence

- Credentials are resolved by trusted connectors; never request or reveal
  their values.
- Operations marked `write_approval` or `compute_approval` require explicit
  operator approval.
- Preserve citations, accessions, versions, parameters, input hashes, catalog
  hash, provider/tool receipts, and artifact hashes.
- Treat absent, blocked, expired, or changed operations as unavailable.
- Never retry through another provider, endpoint, model, or compute target.

Detailed tools, models, connectors, specialists, and compute targets belong
only to the live Science catalog and must not be duplicated in this skill.
