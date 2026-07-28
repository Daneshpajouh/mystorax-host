# Live Conductor snapshot (reference)

Generated from `mystorax_routing_guide`.

```json
{
  "schema": "mystorax.routing_guide.v1",
  "file_capable_bridges": [
    "perplexity",
    "chatgpt"
  ],
  "text_only_bridges": [
    "gemini"
  ],
  "hands_order": [
    "gemini",
    "copilot",
    "codex",
    "cursor-agent",
    "claude"
  ],
  "hard_refused_count": 22,
  "science_max_auto_phase": "EVIDENCE",
  "doctrine": {
    "perplexity": "fast_hard_web_file_capable_multi_step",
    "chatgpt": "fast_auto_instant_or_deep_thinking_pro_file_capable_multi_step_hours_ok",
    "gemini": "text_long_context_no_files",
    "science_os": "durable_multiphase_resume_stop_at_evidence_never_auto_certify",
    "hands": "thin_apply_download_check_only_skip_unavailable",
    "anti_fragment": "never_split_bridge_projects_into_tiny_asks",
    "mcp": "fail_closed_until_MYSTORAX_AXIOM_MCP_TOKEN",
    "front_agnostic": "http_ssot_plus_thin_conductor_mcp_plus_gateway_plugin",
    "native_depth": "conductor_effort_maps_per_worker_never_shared_names"
  },
  "capability_registry_note": "Enforcement source for conductor routing/CI. No local LLMs. Agy is inventory-only (no Hands WorkerKind)."
}
```
