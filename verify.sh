#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OFFLINE=false

if [[ "${1:-}" == "--offline" ]]; then
  OFFLINE=true
elif [[ $# -gt 0 ]]; then
  echo "Usage: ./verify.sh [--offline]" >&2
  exit 2
fi

python3 - "$ROOT" <<'PY'
from __future__ import annotations

import json
import pathlib
import py_compile
import re
import sys

root = pathlib.Path(sys.argv[1])
expected_version = "2.0.1"
expected_skills = {
    "mystorax-platform",
    "mystorax-routing",
    "mystorax-submit-goal",
    "mystorax-bridges-authors",
    "mystorax-hands-thin",
    "mystorax-hard-refuses",
    "mystorax-science-os",
    "mystorax-wait-wake",
    "mystorax-cost-human-gate",
    "mystorax-connectors-credentials",
    "mystorax-front-onboard",
    "mystorax-hosts-manifest",
    "mystorax-capability-surfaces",
    "mystorax-perplexity-sources",
    "mystorax-author-session",
}

version = (root / "VERSION").read_text(encoding="utf-8").strip()
assert version == expected_version, (version, expected_version)

json_paths = [
    root / ".mcp.json",
    root / ".cursor-plugin/plugin.json",
    root / ".claude-plugin/plugin.json",
    root / ".codex-plugin/plugin.json",
]
for path in json_paths:
    json.loads(path.read_text(encoding="utf-8"))

found = set()
for path in sorted((root / "skills").glob("*/SKILL.md")):
    text = path.read_text(encoding="utf-8")
    match = re.match(
        r"^---\nname:\s*([^\n]+)\ndescription:\s*>\n(?:  .+\n)+---\n",
        text,
    )
    assert match, f"invalid YAML frontmatter: {path}"
    name = match.group(1).strip()
    assert name == path.parent.name, f"name/path mismatch: {path}"
    found.add(name)

assert found == expected_skills, (found - expected_skills, expected_skills - found)

py_compile.compile(
    str(root / "scripts/conductor_mcp_server.py"),
    doraise=True,
)

for shell_path in (root / "install.sh", root / "verify.sh"):
    first = shell_path.read_text(encoding="utf-8").splitlines()[0]
    assert first == "#!/usr/bin/env bash", shell_path

all_text = "\n".join(
    path.read_text(encoding="utf-8", errors="replace")
    for path in root.rglob("*")
    if path.is_file() and ".git" not in path.parts
)
for required in (
    "https://mx.parallex.ca",
    "/v1/hosts/manifest",
    "/v1/routing-guide",
    "/v1/surfaces",
    "/v1/goal",
    "never auto-CERTIFY",
):
    assert required in all_text, required

mcp_text = (root / ".mcp.json").read_text(encoding="utf-8")
install_text = (root / "install.sh").read_text(encoding="utf-8")
assert "MYSTORAX_HOST_TOKEN=" not in mcp_text
assert 'cfg["env"]["MYSTORAX_HOST_TOKEN"]' not in install_text
assert 'servers["mystorax-conductor"]' in install_text
print("STATIC_OK")
PY

mcp_output="$(
  printf '%s\n%s\n' \
    '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}' \
    '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}' |
  MYSTORAX_CONDUCTOR_URL='http://127.0.0.1:9' \
  MYSTORAX_HTTP_TIMEOUT_S='0.2' \
  python3 "$ROOT/scripts/conductor_mcp_server.py"
)"

MCP_OUTPUT="$mcp_output" python3 - <<'PY'
import json
import os

messages = [json.loads(line) for line in os.environ["MCP_OUTPUT"].splitlines() if line]
assert messages[0]["result"]["serverInfo"]["name"] == "mystorax-conductor"
tools = messages[1]["result"]["tools"]
assert len(tools) == 10, len(tools)
assert tools[0]["name"] == "mystorax_routing_guide"
assert any(tool["name"] == "mystorax_submit_goal" for tool in tools)
print("MCP_OK")
PY

if $OFFLINE; then
  echo "MYSTORAX_OFFLINE_OK"
  exit 0
fi

: "${MYSTORAX_HOST_TOKEN:?set MYSTORAX_HOST_TOKEN or use --offline}"

python3 - <<'PY'
from __future__ import annotations

import json
import os
import time
import urllib.parse
import urllib.request

base = (os.environ.get("MYSTORAX_CONDUCTOR_URL") or "https://mx.parallex.ca").rstrip("/")
token = os.environ["MYSTORAX_HOST_TOKEN"].strip()
deadline = time.time() + float(os.environ.get("MYSTORAX_VERIFY_TIMEOUT_S") or "180")


def request(method: str, path: str, body=None, auth=False, timeout=30):
    headers = {"Accept": "application/json", "User-Agent": "mystorax-host-verify/2.0.1"}
    data = None
    if body is not None:
        data = json.dumps(body).encode("utf-8")
        headers["Content-Type"] = "application/json"
    if auth:
        headers["Authorization"] = f"Bearer {token}"
    req = urllib.request.Request(base + path, data=data, headers=headers, method=method)
    with urllib.request.urlopen(req, timeout=timeout) as response:
        raw = response.read().decode("utf-8", "replace")
        return response.status, json.loads(raw) if raw else {}


status, manifest = request("GET", "/v1/hosts/manifest")
assert status == 200
assert manifest.get("conductor_http") or manifest.get("public_base")

payload = {
    "text": "Reply with exactly: MYSTORAX_OK",
    "host": "verify_sh",
    "job_class": "research",
    "effort": "low",
    "dispatch": True,
    "async_mode": False,
    "bridge_opts": {"sources": ["web"]},
}
status, result = request("POST", "/v1/goal", payload, auth=True, timeout=120)
assert status in {200, 202}, status


def contains_ok(value) -> bool:
    return "MYSTORAX_OK" in json.dumps(value, ensure_ascii=False)


if contains_ok(result):
    print("MYSTORAX_OK")
    raise SystemExit(0)

job_id = (
    result.get("job_id")
    or result.get("wait_id")
    or (result.get("job") or {}).get("job_id")
    or (result.get("data") or {}).get("job_id")
)
if not job_id:
    raise SystemExit(f"goal returned no MYSTORAX_OK or durable ID: {result}")

quoted = urllib.parse.quote(str(job_id), safe="")
while time.time() < deadline:
    _, current = request("GET", f"/v1/jobs/{quoted}/status", auth=True, timeout=30)
    if contains_ok(current):
        print("MYSTORAX_OK")
        raise SystemExit(0)
    terminal = str(
        current.get("phase")
        or current.get("status")
        or current.get("gate_status")
        or ""
    ).lower()
    if terminal in {
        "failed",
        "cancelled",
        "canceled",
        "cost_budget_exhausted",
        "goal_cost_parked",
        "refused",
    }:
        raise SystemExit(f"goal ended without MYSTORAX_OK: {current}")
    time.sleep(2)

raise SystemExit("timed out waiting for MYSTORAX_OK")
PY
