#!/usr/bin/env bash
# Uninstall MystoraX host package from local fronts (keeps secrets).
set -euo pipefail
rm -rf "${HOME}/.cursor/plugins/local/mystorax-host"
rm -rf "${HOME}/.cursor/plugins/local/mystorax-skills"   # legacy name
rm -rf "${HOME}/.cursor/plugins/local/mystorax-gateway"
rm -rf "${HOME}/.claude/plugins/local/mystorax-host"
rm -rf "${HOME}/.claude/plugins/local/mystorax-skills"
# Remove MCP registration only for mystorax-conductor (preserve other servers)
python3 - <<'PY'
import json
from pathlib import Path
p = Path.home() / ".cursor" / "mcp.json"
if p.is_file():
    try:
        data = json.loads(p.read_text())
    except Exception:
        raise SystemExit(0)
    servers = data.get("mcpServers") or {}
    if "mystorax-conductor" in servers:
        del servers["mystorax-conductor"]
        data["mcpServers"] = servers
        p.write_text(json.dumps(data, indent=2) + "\n")
        print("removed mystorax-conductor from", p)
PY
for base in "${HOME}/.claude/skills" "${HOME}/.codex/skills"; do
  [[ -d "$base" ]] || continue
  for d in "$base"/mystorax-*; do
    [[ -e "$d" ]] || continue
    rm -rf "$d"
    echo "removed $d"
  done
done
echo "uninstall_done (secrets retained)"
