#!/usr/bin/env bash
# Remove only installer-owned, unmodified mystorax-host content. Secrets are retained.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
LEDGER="$HOME/.mystorax/host-install/ownership.json"
if [[ ! -f "$LEDGER" ]]; then
  echo "no ownership ledger; refusing broad cleanup" >&2
  exit 3
fi

# Remove official-CLI registrations only when the ledger says this installer created them.
for front in claude codex; do
  owned="$(python3 - "$LEDGER" "$front" <<'PY'
import json, sys
d=json.load(open(sys.argv[1]))
r=(d.get("registrations") or {}).get(sys.argv[2]) or {}
print("yes" if r.get("created_by_installer") else "no")
PY
)"
  if [[ "$owned" == yes ]] && command -v "$front" >/dev/null 2>&1; then
    if [[ "$front" == claude ]]; then claude mcp remove --scope user mystorax-conductor || true
    else codex mcp remove mystorax-conductor || true
    fi
  fi
done

python3 "$ROOT/scripts/install_state.py" uninstall \
  --ledger "$LEDGER" --version "$(tr -d ' \r\n' < "$ROOT/VERSION")" --home "$HOME"
echo "uninstall_done (secrets and modified/user-owned content retained)"
