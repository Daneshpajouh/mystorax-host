#!/usr/bin/env bash
# Refresh OpenAPI snapshot from live Conductor (no secrets).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
URL="${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}/v1/hosts/chatgpt/openapi.yaml"
OUT="$ROOT/openapi/conductor.openapi.yaml"
mkdir -p "$ROOT/openapi"
curl -fsS "$URL" -o "$OUT"
echo "wrote $OUT ($(wc -l < "$OUT") lines)"
