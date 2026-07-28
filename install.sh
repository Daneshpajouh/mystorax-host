#!/usr/bin/env bash
# Install the full MystoraX host package on every local front.
# Components: Cursor/Claude/Codex plugins, skills, rules, commands, MCP, OpenAPI notes.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
CONDUCTOR_URL="${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}"
SERVER_PY="$ROOT/scripts/conductor_mcp_server.py"
TOKEN_FILE="${MYSTORAX_HOST_TOKEN_FILE:-$HOME/.mystorax/secrets/host_ingress_token}"
TOKEN="${MYSTORAX_HOST_TOKEN:-}"
if [[ -z "$TOKEN" && -f "$TOKEN_FILE" ]]; then
  TOKEN="$(tr -d ' \n\r' < "$TOKEN_FILE")"
fi

chmod +x "$ROOT/install.sh" "$ROOT/verify.sh" "$ROOT/uninstall.sh" \
  "$ROOT/scripts/refresh_openapi.sh" 2>/dev/null || true

mcp_cfg_json() {
  python3 - <<PY
import json
cfg = {
  "command": "python3",
  "args": ["""$SERVER_PY"""],
  "env": {"MYSTORAX_CONDUCTOR_URL": """$CONDUCTOR_URL"""},
}
token = """$TOKEN"""
if token:
  cfg["env"]["MYSTORAX_HOST_TOKEN"] = token
print(json.dumps({"mcpServers": {"mystorax-conductor": cfg}}, indent=2))
PY
}

# --- Cursor plugin (full package) ---
CURSOR_DST="${HOME}/.cursor/plugins/local/mystorax-host"
mkdir -p "$(dirname "$CURSOR_DST")"
rsync -a --delete --exclude '.git' --exclude 'python/*.egg-info' --exclude '**/__pycache__' "$ROOT/" "$CURSOR_DST/"
mcp_cfg_json > "$CURSOR_DST/.mcp.json"
echo "cursor_plugin=$CURSOR_DST"
# Drop legacy skills-named install
rm -rf "${HOME}/.cursor/plugins/local/mystorax-skills"

# Also install as mystorax-gateway alias (older Settings / manifests)
GATEWAY_DST="${HOME}/.cursor/plugins/local/mystorax-gateway"
rsync -a --delete --exclude '.git' --exclude 'python/*.egg-info' --exclude '**/__pycache__' "$ROOT/" "$GATEWAY_DST/"
# Keep gateway plugin name for Settings that still look for mystorax-gateway
python3 - <<PY
import json
from pathlib import Path
for name in (".cursor-plugin", ".claude-plugin", ".codex-plugin"):
    p = Path("""$GATEWAY_DST""") / name / "plugin.json"
    if not p.is_file():
        continue
    data = json.loads(p.read_text())
    data["name"] = "mystorax-gateway"
    data["description"] = "Alias install of mystorax-host host package (front-agnostic Conductor)."
    p.write_text(json.dumps(data, indent=2) + "\n")
PY
mcp_cfg_json > "$GATEWAY_DST/.mcp.json"
echo "cursor_gateway_alias=$GATEWAY_DST"

# User MCP merge
USER_MCP="${HOME}/.cursor/mcp.json"
python3 - <<PY
import json
from pathlib import Path
user_mcp = Path("""$USER_MCP""")
cfg = {
  "command": "python3",
  "args": ["""$SERVER_PY"""],
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

# --- Claude Code + Codex skills ---
for base in "${HOME}/.claude/skills" "${HOME}/.codex/skills"; do
  mkdir -p "$base"
  for d in "$ROOT"/skills/*; do
    [[ -d "$d" ]] || continue
    name="$(basename "$d")"
    rsync -a "$d/" "$base/$name/"
  done
  rm -rf "$base/mystorax-claude-science-onboard"
  echo "skills synced -> $base"
done

# Claude plugin dir (optional --plugin-dir)
CLAUDE_PLUGIN_DST="${HOME}/.claude/plugins/local/mystorax-host"
mkdir -p "$(dirname "$CLAUDE_PLUGIN_DST")"
rsync -a --delete --exclude '.git' --exclude 'python/*.egg-info' --exclude '**/__pycache__' "$ROOT/" "$CLAUDE_PLUGIN_DST/"
mcp_cfg_json > "$CLAUDE_PLUGIN_DST/.mcp.json"
echo "claude_plugin=$CLAUDE_PLUGIN_DST"

# --- Optional pip MCP entrypoint ---
if command -v pip3 >/dev/null 2>&1; then
  pip3 install -e "$ROOT" --quiet 2>/dev/null && echo "pip_mcp=mystorax-conductor-mcp" || echo "pip_mcp=skipped"
else
  echo "pip_mcp=skipped"
fi

echo "host_token_set=$([[ -n "$TOKEN" ]] && echo yes || echo no)"
echo "chatgpt_openapi_live=$CONDUCTOR_URL/v1/hosts/chatgpt/openapi.yaml"
echo "chatgpt_openapi_pack=$ROOT/openapi/conductor.openapi.yaml"
echo "manifest=$CONDUCTOR_URL/v1/hosts/manifest"
echo "connectors=$ROOT/connectors/"
echo "verify=$ROOT/verify.sh"
echo "version=$(tr -d ' \n' < "$ROOT/VERSION" 2>/dev/null || echo unknown)"
echo "done"
