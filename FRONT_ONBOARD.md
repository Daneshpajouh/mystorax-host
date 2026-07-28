# MystoraX Front Onboarding

All fronts are equal peers. Each front bootstraps from Conductor, reads routing doctrine, inspects capability surfaces, and submits goals through the same HTTP source of truth.

## Shared contract

Set these values through the shell or the front's credential UI:

```bash
export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN='replace-through-a-secret-store'
```

Never commit the token. Never copy it into a skill, prompt, plugin manifest, screenshot, issue, or chat transcript.

Every front uses this sequence:

1. `GET /v1/hosts/manifest`
2. `GET /v1/routing-guide`
3. `GET /v1/surfaces`
4. `POST /v1/goal`

Read `AGENTS.md` before operating.

## HTTP and curl

### Connect

No plugin is required. Use the recipes in `connectors/mystorax-conductor.md`.

### Discover

```bash
BASE="${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}"
curl -fsS "$BASE/v1/hosts/manifest"
curl -fsS "$BASE/v1/routing-guide"
curl -fsS "$BASE/v1/surfaces"
```

### Submit

```bash
curl -fsS -X POST "$BASE/v1/goal" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"text":"Describe the goal","host":"http_curl","job_class":"research","dispatch":true}'
```

### Boundary

The HTTP client is a thin peer. It must not reimplement routing or contact bridges directly.

## Cursor

### Install

```bash
./install.sh --cursor
```

This installs the local plugin pack, copies doctrine modules in Agent Skills format, and registers the stdio MCP server in `~/.cursor/mcp.json`. The installer stores no token.

### Discover

Call:

1. `mystorax_routing_guide`
2. `mystorax_surfaces`
3. `mystorax_submit_goal`

Use `mystorax_capability_lookup` when the surface list is large.

### Operate

Cursor may inspect, edit, and verify a working tree only as a thin front or Hands client. Conductor remains the source of routing and goal state.

### Boundary

Do not treat Cursor's model choice, modes, or local rules as MystoraX doctrine.

## Claude Code

### Install

```bash
./install.sh --claude
```

This copies all `skills/*` doctrine modules into `~/.claude/skills`. Register `.mcp.json` through Claude Code's MCP settings or CLI.

### Discover

Call the same three-tool sequence:

1. `mystorax_routing_guide`
2. `mystorax_surfaces`
3. `mystorax_submit_goal`

### Operate

Claude Code may act as a thin front and, when selected in the Hands chain, may apply or check an authored package.

### Boundary

Claude Code does not own author selection, Science OS progression, or certification.

## Claude Science

### Install

Use the same doctrine modules and MCP server as Claude Code. A separate Conductor contract is not required.

### Discover

Call:

1. `mystorax_routing_guide`
2. `mystorax_surfaces`
3. `mystorax_submit_goal`

For scientific work, also call `mystorax_science_status`.

### Operate

Submit scientific goals with `job_class: "science"`. Use durable campaign status and checkpoints returned by Conductor.

### Boundary

Auto-resume stops at `EVIDENCE`. A human or approved certification process must authorize `CERTIFY`. Claude Science is not a privileged control plane.

## Codex

### Install

```bash
./install.sh --codex
```

This copies all doctrine modules into `~/.codex/skills`. Register the stdio MCP server using `.mcp.json`.

### Discover

Call:

1. `mystorax_routing_guide`
2. `mystorax_surfaces`
3. `mystorax_submit_goal`

### Operate

Codex may be a thin front. In the Hands order, it appears after Gemini and Copilot, and before Cursor Agent and Claude.

### Boundary

Codex must not silently replace an active author session. Escalate before switching authors.

## ChatGPT Actions and Desktop

### Install

For Actions, import:

```text
https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml
```

A local copy is available at `openapi/conductor.openapi.yaml`.

For Desktop, register `.mcp.json` or an equivalent local MCP entry.

### Discover

Actions should call `getRoutingGuide`, then `listSurfaces`, then `submitGoal`. Desktop should use the equivalent MCP tools.

### Operate

ChatGPT may author file packages when Conductor selects it. It may also act only as the front while another bridge authors.

### Boundary

Do not infer direct bridge endpoints from the OpenAPI schema. Submit through Conductor.

## Gemini as a front

### Install

Configure the surrounding host to use the raw HTTP contract or the included MCP server. Gemini itself does not need a separate MystoraX control plane.

### Discover

Call the same sequence through the host:

1. routing guide
2. surfaces
3. submit goal

### Operate

Gemini is text-only in the author plane. In the Hands chain, Gemini may apply, download, or check within the thin scope.

### Boundary

Gemini must not author file packages. Do not use Spark or computer-use surfaces.

## Custom MCP host

### Install

Register:

```json
{
  "mcpServers": {
    "mystorax-conductor": {
      "command": "python3",
      "args": ["/absolute/path/to/mystorax-host/scripts/conductor_mcp_server.py"],
      "env": {
        "MYSTORAX_CONDUCTOR_URL": "https://mx.parallex.ca"
      }
    }
  }
}
```

Supply `MYSTORAX_HOST_TOKEN` through the host's credential UI or inherited environment.

### Discover

Use the same three-tool sequence. Tool names and schemas are available from `GET /v1/hosts/mcp/tools`.

### Boundary

The custom host is a peer adapter, not a routing authority.

## Custom OpenAPI host

### Install

Import `openapi/conductor.openapi.yaml`, or use the live ChatGPT-compatible schema.

### Discover

Call the manifest, routing guide, and surfaces operations before goal submission.

### Boundary

The OpenAPI client must preserve unknown response fields, durable IDs, gate states, and evidence rather than reducing them to a local status model.

## Failure handling

- A `401` or `403` means the front credential is missing or rejected.
- A refused surface stays refused. Do not retry it through another front.
- A parked cost gate requires operator action.
- An irreversible Hands action requires an approved human gate.
- A long-running goal should use job status or wait-stream guidance.
- A bridge failure should be escalated before author switching.
