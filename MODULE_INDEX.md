# MystoraX task-to-module index

All modules are peer-front doctrine in Agent Skills wire format. Live capability truth remains the Conductor manifest, routing guide, surfaces catalog, and OpenAPI.

| Task | Load module | MCP tool | HTTP equivalent | Minimal example |
|---|---|---|---|---|
| Understand MystoraX | `mystorax-platform` | `mystorax_routing_guide` | `GET /v1/routing-guide` | Discover policy before choosing a route |
| Bootstrap a front | `mystorax-hosts-manifest` | — (HTTP bootstrap) | `GET /v1/hosts/manifest` | List live tools and Hands |
| Choose a route | `mystorax-routing` | `mystorax_routing_guide` | `GET /v1/routing-guide` | Pick author, effort, and thin Hand |
| Submit work | `mystorax-submit-goal` | `mystorax_submit_goal` | `POST /v1/goal` | `{"text":"…","job_class":"research","dispatch":true}` |
| Wait for work | `mystorax-wait-wake` | `mystorax_job_status` | `GET /v1/jobs/{id}/status` | Poll the returned `job_id` |
| Choose an author | `mystorax-bridges-authors` | `mystorax_routing_guide` | `GET /v1/routing-guide` | Files use ChatGPT/Perplexity; Gemini text-only |
| Apply an artifact | `mystorax-hands-thin` | — (HTTP bootstrap) | `GET /v1/hosts/manifest` | Use the first healthy thin Hand |
| Reject prohibited work | `mystorax-hard-refuses` | `mystorax_capability_lookup` | `GET /v1/surfaces` | Confirm refused surface; do not dispatch |
| Discover capabilities | `mystorax-capability-surfaces` | `mystorax_surfaces` | `GET /v1/surfaces` | Filter `wired`, `guided`, `inventory`, `refused` |
| Configure transport/auth | `mystorax-connectors-credentials` | — (HTTP bootstrap) | `GET /v1/hosts/manifest` | Reference the local token file; never copy its value |
| Keep long work coherent | `mystorax-author-session` | `mystorax_submit_goal` | `POST /v1/goal` | Reuse `metadata.author_session` |
| Handle cost/approval | `mystorax-cost-human-gate` | `mystorax_job_status` | `GET /v1/jobs/{id}/status` | Halt on 402/409; request operator action |
| Run Science | `mystorax-science-os` | `mystorax_science_resume` | `POST /v1/hosts/mcp/tools/call` | Resume at most to `EVIDENCE` |
| Offload research/brainstorm | `mystorax-front-heavy-lift` | `mystorax_submit_goal` | `POST /v1/goal` | Preserve front usage; bridges do heavy lift |
| Select research sources | `mystorax-perplexity-sources` | `mystorax_submit_goal` | `POST /v1/goal` | `bridge_opts.sources:["academic"]` |
| Onboard a peer front | `mystorax-front-onboard` | — (HTTP bootstrap) | `GET /v1/hosts/manifest` | Follow the matching connector card |

Every module answers what, when, how, and the exact call to use. The copy/paste connector cards add front-specific installation, authentication, smoke, and troubleshooting.
