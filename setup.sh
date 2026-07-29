#!/usr/bin/env bash
# MystoraX one-command setup: token → install → verify → print how to use.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
VERSION="$(tr -d ' \r\n' < "$ROOT/VERSION")"
CONDUCTOR_URL="${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}"
TOKEN_FILE="${MYSTORAX_HOST_TOKEN_FILE:-$HOME/.mystorax/secrets/host_ingress_token}"
FRONT="${MX_FRONT:-all}"
SKIP_VERIFY=0
TOKEN_VALUE=""

usage() {
  cat <<'EOF'
MystoraX setup — one command for this Mac.

  ./setup.sh
  ./setup.sh --token PASTE_YOUR_TOKEN
  ./setup.sh --front cursor|claude|codex|all

Then use:

  ./mx "your question"
  ./mx status <job_id>

EOF
}

while (($#)); do
  case "$1" in
    --token) TOKEN_VALUE="${2:?missing token}"; shift 2 ;;
    --front) FRONT="${2:?missing front}"; shift 2 ;;
    --skip-verify) SKIP_VERIFY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done

mkdir -p "$(dirname "$TOKEN_FILE")"
chmod 700 "$(dirname "$TOKEN_FILE")" 2>/dev/null || true

if [[ -n "$TOKEN_VALUE" ]]; then
  printf '%s\n' "$TOKEN_VALUE" > "$TOKEN_FILE"
  chmod 600 "$TOKEN_FILE"
  echo "token=saved ($TOKEN_FILE)"
elif [[ -n "${MYSTORAX_HOST_TOKEN:-}" && ! -f "$TOKEN_FILE" ]]; then
  printf '%s\n' "$MYSTORAX_HOST_TOKEN" > "$TOKEN_FILE"
  chmod 600 "$TOKEN_FILE"
  echo "token=saved-from-env ($TOKEN_FILE)"
fi

if [[ ! -f "$TOKEN_FILE" && -z "${MYSTORAX_HOST_TOKEN:-}" ]]; then
  cat >&2 <<EOF
Missing host token.

Put your issued token here:
  $TOKEN_FILE

Or run:
  ./setup.sh --token PASTE_YOUR_TOKEN
EOF
  exit 3
fi

export MYSTORAX_CONDUCTOR_URL="$CONDUCTOR_URL"
export MYSTORAX_HOST_TOKEN_FILE="$TOKEN_FILE"
export MYSTORAX_HOST_TOKEN="${MYSTORAX_HOST_TOKEN:-$(cat "$TOKEN_FILE")}"

echo "→ installing MystoraX $VERSION ($FRONT)"
"$ROOT/install.sh" --front "$FRONT"

echo "→ checking install"
"$ROOT/install.sh" --check

if ((SKIP_VERIFY == 0)); then
  echo "→ verifying against $CONDUCTOR_URL"
  "$ROOT/verify.sh" || {
    echo "verify failed — token or network issue. Fix token, then: ./verify.sh" >&2
    exit 1
  }
fi

# Convenience: mx on PATH when ~/.local/bin is available
if [[ -d "$HOME/.local/bin" || mkdir -p "$HOME/.local/bin" ]]; then
  ln -sfn "$ROOT/mx" "$HOME/.local/bin/mx"
  echo "cli=mx → $HOME/.local/bin/mx  (open a new terminal if 'mx' is not found)"
fi

chmod +x "$ROOT/mx" "$ROOT/setup.sh" "$ROOT/install.sh" "$ROOT/verify.sh" 2>/dev/null || true

cat <<EOF

════════════════════════════════════════
 MystoraX $VERSION is ready
════════════════════════════════════════

Ask from any terminal:

  mx "Summarize CRISPR off-target prior art in 10 bullets"
  mx status <job_id>

(or ./mx from this folder)

In Cursor / Claude Code / Codex: reload once, then just ask —
agents use mystorax_submit_goal; bridges do the heavy lift.

════════════════════════════════════════
EOF
