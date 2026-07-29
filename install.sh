#!/usr/bin/env bash
# Install mystorax-host for native peer fronts without copying credential values.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
VERSION="$(tr -d ' \r\n' < "$ROOT/VERSION")"
CONDUCTOR_URL="${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}"
TOKEN_FILE="${MYSTORAX_HOST_TOKEN_FILE:-$HOME/.mystorax/secrets/host_ingress_token}"
FRONT="all"
MODE="install"
DRY_RUN=0
MACHINE=0

usage() {
  echo "usage: ./install.sh [--front all|cursor|claude|codex] [--dry-run|--check] [--machine]"
}
while (($#)); do
  case "$1" in
    --front) FRONT="${2:?missing front}"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --check) MODE="check"; shift ;;
    --machine) MACHINE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done
case "$FRONT" in all|cursor|claude|codex) ;; *) echo "unsupported front: $FRONT" >&2; exit 2 ;; esac

STATE_DIR="$HOME/.mystorax/host-install"
LEDGER="$STATE_DIR/ownership.json"
SERVER_REL="scripts/conductor_mcp_server.py"

want() { [[ "$FRONT" == all || "$FRONT" == "$1" ]]; }
run() {
  if ((DRY_RUN)); then printf 'would_run:'; printf ' %q' "$@"; printf '\n'
  else "$@"
  fi
}

check_token_reference() {
  if [[ -n "${MYSTORAX_HOST_TOKEN:-}" ]]; then
    echo "auth=environment"
  elif [[ -f "$TOKEN_FILE" ]]; then
    echo "auth=token-file"
  else
    echo "auth=missing ($TOKEN_FILE)" >&2
    return 3
  fi
}

check_install() {
  local failed=0
  for path in \
    "$HOME/.cursor/plugins/local/mystorax-host/VERSION" \
    "$HOME/.claude/plugins/local/mystorax-host/VERSION" \
    "$HOME/.codex/plugins/local/mystorax-host/VERSION"; do
    [[ -f "$path" ]] || continue
    [[ "$(tr -d ' \r\n' < "$path")" == "$VERSION" ]] || { echo "version_mismatch=$path" >&2; failed=1; }
  done
  python3 "$ROOT/scripts/install_state.py" check \
    --ledger "$LEDGER" --version "$VERSION" --home "$HOME" || failed=1
  check_token_reference || failed=1
  ((failed == 0)) || return 1
  echo "install_check=PASS version=$VERSION"
}

if [[ "$MODE" == check ]]; then check_install; exit; fi

if ((DRY_RUN == 0)); then
  mkdir -p "$STATE_DIR"
  chmod 700 "$STATE_DIR"
fi

install_tree() {
  local front="$1" dst="$2"
  run mkdir -p "$(dirname "$dst")"
  run rsync -a --delete \
    --exclude .git --exclude '.local' --exclude '*.egg-info' --exclude '__pycache__' \
    "$ROOT/" "$dst/"
  if ((DRY_RUN == 0)); then
    python3 "$ROOT/scripts/install_state.py" own-tree \
      --ledger "$LEDGER" --version "$VERSION" --front "$front" --path "$dst"
  fi
  echo "$front.plugin=$dst"
}

if want cursor; then
  CURSOR_DST="$HOME/.cursor/plugins/local/mystorax-host"
  install_tree cursor "$CURSOR_DST"
  if ((DRY_RUN)); then
    echo "would_register: Cursor mystorax-conductor"
  else
    python3 "$ROOT/scripts/install_state.py" merge-cursor \
      --ledger "$LEDGER" --version "$VERSION" --home "$HOME" \
      --server "$CURSOR_DST/$SERVER_REL" --url "$CONDUCTOR_URL" --token-file "$TOKEN_FILE"
  fi
fi

sync_skills() {
  local front="$1" base="$2"
  run mkdir -p "$base"
  for src in "$ROOT"/skills/*; do
    [[ -d "$src" ]] || continue
    local dst="$base/$(basename "$src")"
    run rsync -a --delete "$src/" "$dst/"
    if ((DRY_RUN == 0)); then
      python3 "$ROOT/scripts/install_state.py" own-tree \
        --ledger "$LEDGER" --version "$VERSION" --front "$front-skill" --path "$dst"
    fi
  done
}

if want claude; then
  CLAUDE_DST="$HOME/.claude/plugins/local/mystorax-host"
  install_tree claude "$CLAUDE_DST"
  sync_skills claude "$HOME/.claude/skills"
  if command -v claude >/dev/null 2>&1; then
    if claude mcp get mystorax-conductor >/dev/null 2>&1; then
      echo "claude.mcp=existing (preserved; verify or remove explicitly before replacement)"
    elif ((DRY_RUN)); then
      echo "would_register: claude mcp mystorax-conductor"
    else
      claude mcp add --scope user mystorax-conductor \
        -e "MYSTORAX_CONDUCTOR_URL=$CONDUCTOR_URL" \
        -e "MYSTORAX_HOST_TOKEN_FILE=$TOKEN_FILE" \
        -- python3 "$CLAUDE_DST/$SERVER_REL"
      python3 "$ROOT/scripts/install_state.py" own-registration \
        --ledger "$LEDGER" --version "$VERSION" --front claude --name mystorax-conductor
    fi
  else
    echo "claude.mcp=NOT_RUN (claude CLI unavailable)"
  fi
fi

if want codex; then
  CODEX_DST="$HOME/.codex/plugins/local/mystorax-host"
  install_tree codex "$CODEX_DST"
  sync_skills codex "$HOME/.codex/skills"

  # Codex app Plugins panel only shows marketplace plugins — register personal.
  PERSONAL_PLUGIN="$HOME/plugins/mystorax-host"
  MARKETPLACE_JSON="$HOME/.agents/plugins/marketplace.json"
  if ((DRY_RUN)); then
    echo "would_register: Codex personal marketplace plugin mystorax-host@personal"
  else
    mkdir -p "$HOME/plugins" "$HOME/.agents/plugins"
    rsync -a --delete \
      --exclude .git --exclude '*.egg-info' --exclude '__pycache__' \
      "$ROOT/" "$PERSONAL_PLUGIN/"
    # Absolute token path in plugin MCP config (HOME expansion is unreliable).
    python3 - "$PERSONAL_PLUGIN" "$TOKEN_FILE" "$CONDUCTOR_URL" <<'PY'
import json, sys
from pathlib import Path
root, token_file, url = Path(sys.argv[1]), sys.argv[2], sys.argv[3]
mcp = {
    "mcpServers": {
        "mystorax-conductor": {
            "command": "python3",
            "args": ["scripts/conductor_mcp_server.py"],
            "cwd": ".",
            "env": {
                "MYSTORAX_CONDUCTOR_URL": url,
                "MYSTORAX_HOST_TOKEN_FILE": token_file,
            },
        }
    }
}
(root / ".mcp.json").write_text(json.dumps(mcp, indent=2) + "\n")
mp = Path.home() / ".agents/plugins/marketplace.json"
if mp.exists():
    data = json.loads(mp.read_text())
else:
    data = {"name": "personal", "interface": {"displayName": "Personal"}, "plugins": []}
names = {p.get("name") for p in data.get("plugins", [])}
if "mystorax-host" not in names:
    data.setdefault("plugins", []).append(
        {
            "name": "mystorax-host",
            "source": {"source": "local", "path": "./plugins/mystorax-host"},
            "policy": {"installation": "AVAILABLE", "authentication": "ON_INSTALL"},
            "category": "Productivity",
        }
    )
    mp.parent.mkdir(parents=True, exist_ok=True)
    mp.write_text(json.dumps(data, indent=2) + "\n")
PY
    if command -v codex >/dev/null 2>&1; then
      if codex plugin list 2>/dev/null | grep -q 'mystorax-host@personal'; then
        echo "codex.plugin=mystorax-host@personal (already installed)"
      else
        codex plugin add mystorax-host@personal >/dev/null
        echo "codex.plugin=mystorax-host@personal installed"
      fi
      if codex mcp get mystorax-conductor >/dev/null 2>&1; then
        echo "codex.mcp=existing (preserved; verify or remove explicitly before replacement)"
      else
        codex mcp add mystorax-conductor \
          --env "MYSTORAX_CONDUCTOR_URL=$CONDUCTOR_URL" \
          --env "MYSTORAX_HOST_TOKEN_FILE=$TOKEN_FILE" \
          -- python3 "$CODEX_DST/$SERVER_REL"
        python3 "$ROOT/scripts/install_state.py" own-registration \
          --ledger "$LEDGER" --version "$VERSION" --front codex --name mystorax-conductor
      fi
    else
      echo "codex.plugin=NOT_RUN (codex CLI unavailable) — files staged at $PERSONAL_PLUGIN"
    fi
  fi
fi

check_token_reference || true

# If env token is set but file is missing, persist it for MCP servers.
if [[ -n "${MYSTORAX_HOST_TOKEN:-}" && ! -f "$TOKEN_FILE" ]]; then
  mkdir -p "$(dirname "$TOKEN_FILE")"
  printf '%s\n' "$MYSTORAX_HOST_TOKEN" > "$TOKEN_FILE"
  chmod 600 "$TOKEN_FILE"
  echo "token=saved ($TOKEN_FILE)"
fi

echo
echo "MystoraX $VERSION installed."
echo "Next: ./setup.sh   (or already done) then  ./mx \"your question\""
echo "Reload Cursor / Claude Code / Codex once so MCP picks up."
echo "Check: ./install.sh --check   Smoke: ./verify.sh"
((MACHINE)) && echo "result=installed version=$VERSION front=$FRONT"
exit 0
