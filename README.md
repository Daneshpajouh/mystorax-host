# mystorax-host

The front-neutral distribution package for MystoraX.

For Claude Science, import this GitHub repository once. It intentionally
publishes exactly two skills:

- `use-mystorax` — universal provider/CLI access
- `use-mystorax-science` — the single consolidated Science capability

The skills contain no duplicated model, connector, tool, or specialist lists.
They discover the current catalog from MystoraX at execution time.

The NVIDIA BioNeMo Agent Toolkit remains a separate imported scientific-model
toolkit. `Codex Delegate` also remains separate because it is a narrow handoff
helper, not a duplicate Science product.

Retired names such as Axiom, CompBio, and Science OS are not separate products
or skills.
