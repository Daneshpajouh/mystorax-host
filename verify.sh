#!/usr/bin/env bash
# Universal host-package smoke. PASS=0, FAILED=1, NOT_RUN=3.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
exec python3 "$ROOT/scripts/verify_host.py" "$@"
