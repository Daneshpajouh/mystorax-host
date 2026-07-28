#!/usr/bin/env bash
# Install the MystoraX host package without persisting credentials.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONDUCTOR_URL="${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}"
SERVER_PY="$ROOT/scripts/conductor_mcp_server.py"

install_cursor=false
install_claude=false
install_codex=false
register_mcp=true
install_pip=true

usage() {
  cat <<'EOF'
Usage: ./install.sh [--all] [--cursor] [--claude] [--codex] [--no-mcp] [--no-pip]

Default: --all

The installer never stores MYSTORAX_HOST_TOKEN. Supply credentials through
the process environment or the front's credential UI.
EOF
}

if [[ $# -eq 0 ]]; then
  install_cursor=true
  install_claude=true
  install_codex=true
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      install_cursor=true
      install_claude=true
      install_codex=true
      ;;
    --cursor) install_cursor=true ;;
    --claude) install_claude=true ;;
    --codex) install_codex=true ;;
    --no-mcp) register_mcp=false ;;
    --no-pip) install_pip=false ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

copy_tree() {
  local src="$1"
  local dst="$2"
  mkdir -p "$dst"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete \
      --exclude '.git' \
      --exclude '**/__pycache__' \
      --exclude 'python/*.egg-info' \
      "$src/" "$dst/"
  else
    rm -rf "$dst"
    mkdir -p "$dst"
    cp -R "$src/." "$dst/"
    rm -rf "$dst/.git"
    find "$dst" -type d -name __pycache__ -prune -exec rm -rf {} +
  fi
}

copy_skills() {
  local dst_root="$1"
  mkdir -p "$dst_root"
  local skill_dir
  for skill_dir in "$ROOT"/skills/*; do
    [[ -d "$skill_dir" ]] || continue
    copy_tree "$skill_dir" "$dst_root/$(basename "$skill_dir")"
  done
}

write_mcp_config() {
  local path="$1"
  local server="$2"
  mkdir -p "$(dirname "$path")"
  MCP_PATH="$path" SERVER_PY="$server" CONDUCTOR_URL="$CONDUCTOR_URL" python3 - <<'PY'
import json
import os
from pathlib import Path

path = Path(os.environ["MCP_PATH"])
data = {"mcpServers": {}}
if path.is_file():
    try:
        loaded = json.loads(path.read_text(encoding="utf-8"))
        if isinstance(loaded, dict):
            data = loaded
    except (OSError, json.JSONDecodeError):
        backup = path.with_suffix(path.suffix + ".bak")
        backup.write_bytes(path.read_bytes())
        data = {"mcpServers": {}}

servers = data.setdefault("mcpServers", {})
if not isinstance(servers, dict):
    servers = {}
    data["mcpServers"] = servers

servers["mystorax-conductor"] = {
    "command": "python3",
    "args": [os.environ["SERVER_PY"]],
    "env": {
        "MYSTORAX_CONDUCTOR_URL": os.environ["CONDUCTOR_URL"],
    },
}
path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY
}

chmod +x "$ROOT/install.sh" "$ROOT/verify.sh" "$ROOT/uninstall.sh" \
  "$ROOT/scripts/conductor_mcp_server.py" "$ROOT/scripts/refresh_openapi.sh" \
  2>/dev/null || true

if $install_cursor; then
  cursor_plugin="$HOME/.cursor/plugins/local/mystorax-host"
  copy_tree "$ROOT" "$cursor_plugin"
  write_mcp_config "$cursor_plugin/.mcp.json" "$SERVER_PY"
  echo "cursor_plugin=$cursor_plugin"

  # Compatibility alias for older host registrations.
  gateway_plugin="$HOME/.cursor/plugins/local/mystorax-gateway"
  copy_tree "$ROOT" "$gateway_plugin"
  write_mcp_config "$gateway_plugin/.mcp.json" "$SERVER_PY"
  echo "cursor_gateway_alias=$gateway_plugin"

  rm -rf "$HOME/.cursor/plugins/local/mystorax-skills"

  if $register_mcp; then
    write_mcp_config "$HOME/.cursor/mcp.json" "$SERVER_PY"
    echo "cursor_mcp=$HOME/.cursor/mcp.json"
  fi
fi

if $install_claude; then
  copy_skills "$HOME/.claude/skills"
  claude_plugin="$HOME/.claude/plugins/local/mystorax-host"
  copy_tree "$ROOT" "$claude_plugin"
  write_mcp_config "$claude_plugin/.mcp.json" "$SERVER_PY"
  echo "claude_skills=$HOME/.claude/skills"
  echo "claude_plugin=$claude_plugin"
fi

if $install_codex; then
  copy_skills "$HOME/.codex/skills"
  echo "codex_skills=$HOME/.codex/skills"
fi

if $install_pip && command -v pip3 >/dev/null 2>&1; then
  pip3 install -e "$ROOT" --quiet 2>/dev/null \
    && echo "pip_mcp=mystorax-conductor-mcp" \
    || echo "pip_mcp=skipped"
fi

"$ROOT/verify.sh" --offline

cat <<EOF
MystoraX host package installed.

Conductor: $CONDUCTOR_URL
MCP server: $SERVER_PY
OpenAPI: $ROOT/openapi/conductor.openapi.yaml

Credentials were not stored.
Export MYSTORAX_HOST_TOKEN or set it in the front credential UI.
Run ./verify.sh for the live MYSTORAX_OK smoke test.
EOF
