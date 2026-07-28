#!/usr/bin/env bash
# Install MystoraX skills for every local front (Cursor, Claude Code, Codex).
# ChatGPT / HTTP fronts use OpenAPI + Bearer — printed at end.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
CONDUCTOR_URL="${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}"
SERVER="$ROOT/scripts/conductor_mcp_server.py"
TOKEN_FILE="${MYSTORAX_HOST_TOKEN_FILE:-$HOME/.mystorax/secrets/host_ingress_token}"
TOKEN="${MYSTORAX_HOST_TOKEN:-}"
if [[ -z "$TOKEN" && -f "$TOKEN_FILE" ]]; then
  TOKEN="$(tr -d ' \n\r' < "$TOKEN_FILE")"
fi

write_mcp() {
  local dst="$1"
  python3 - <<PY
import json
from pathlib import Path
dst = Path("""$dst""")
dst.parent.mkdir(parents=True, exist_ok=True)
cfg = {
  "command": "python3",
  "args": ["""$SERVER"""],
  "env": {"MYSTORAX_CONDUCTOR_URL": """$CONDUCTOR_URL"""},
}
token = """$TOKEN"""
if token:
  cfg["env"]["MYSTORAX_HOST_TOKEN"] = token
dst.write_text(json.dumps({"mcpServers": {"mystorax-conductor": cfg}}, indent=2) + "\n")
print("wrote", dst)
PY
}

CURSOR_DST="${HOME}/.cursor/plugins/local/mystorax-skills"
mkdir -p "$(dirname "$CURSOR_DST")"
rsync -a --delete --exclude '.git' "$ROOT/" "$CURSOR_DST/"
write_mcp "$CURSOR_DST/.mcp.json"

USER_MCP="${HOME}/.cursor/mcp.json"
python3 - <<PY
import json
from pathlib import Path
user_mcp = Path("""$USER_MCP""")
cfg = {
  "command": "python3",
  "args": ["""$SERVER"""],
  "env": {"MYSTORAX_CONDUCTOR_URL": """$CONDUCTOR_URL"""},
}
token = """$TOKEN"""
if token:
    cfg["env"]["MYSTORAX_HOST_TOKEN"] = token
data = {"mcpServers": {}}
if user_mcp.is_file():
    try:
        data = json.loads(user_mcp.read_text())
        data.setdefault("mcpServers", {})
    except Exception:
        data = {"mcpServers": {}}
data["mcpServers"]["mystorax-conductor"] = cfg
user_mcp.parent.mkdir(parents=True, exist_ok=True)
user_mcp.write_text(json.dumps(data, indent=2) + "\n")
print("registered", user_mcp)
PY

for base in "${HOME}/.claude/skills" "${HOME}/.codex/skills"; do
  mkdir -p "$base"
  for d in "$ROOT"/skills/*; do
    [[ -d "$d" ]] || continue
    name="$(basename "$d")"
    rsync -a "$d/" "$base/$name/"
  done
  # Drop renamed legacy skill if present
  rm -rf "$base/mystorax-claude-science-onboard"
  echo "skills synced -> $base"
done

echo "host_token_set=$([[ -n "$TOKEN" ]] && echo yes || echo no)"
echo "chatgpt_openapi=$CONDUCTOR_URL/v1/hosts/chatgpt/openapi.yaml"
echo "manifest=$CONDUCTOR_URL/v1/hosts/manifest"
echo "front_onboard=see FRONT_ONBOARD.md (all fronts equal)"
echo "done"
