#!/usr/bin/env bash
# Smoke MystoraX Conductor from any machine with host token.
set -euo pipefail
CONDUCTOR_URL="${MYSTORAX_CONDUCTOR_URL:-https://mx.parallex.ca}"
TOKEN_FILE="${MYSTORAX_HOST_TOKEN_FILE:-$HOME/.mystorax/secrets/host_ingress_token}"
TOKEN="${MYSTORAX_HOST_TOKEN:-}"
if [[ -z "$TOKEN" && -f "$TOKEN_FILE" ]]; then
  TOKEN="$(tr -d ' \n\r' < "$TOKEN_FILE")"
fi
if [[ -z "$TOKEN" ]]; then
  echo "missing MYSTORAX_HOST_TOKEN" >&2
  exit 1
fi

echo "== health =="
curl -fsS "$CONDUCTOR_URL/health" | head -c 400
echo
echo "== manifest =="
curl -fsS "$CONDUCTOR_URL/v1/hosts/manifest" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('doctrine_version'), d.get('manifest_version'), 'tools', (d.get('conductor_mcp') or {}).get('tool_count'))"
echo "== routing_guide =="
curl -fsS -H "Authorization: Bearer $TOKEN" "$CONDUCTOR_URL/v1/routing-guide" | python3 -c "import sys,json; d=json.load(sys.stdin); print('schema', d.get('schema')); print('hands', d.get('hands_order')); print('science_max_auto', d.get('science_max_auto_phase'))"
echo "== submit_goal MYSTORAX_OK =="
RESP="$(curl -fsS -X POST "$CONDUCTOR_URL/v1/goal" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"text":"Reply with exactly: MYSTORAX_OK","job_class":"research","effort":"low","dispatch":true,"async_mode":true,"host":"custom","metadata":{"prefer":"perplexity"},"bridge_opts":{"sources":["web"],"mode":"concise"}}')"
echo "$RESP" | python3 -c "import sys,json; d=json.load(sys.stdin); print('accepted', d.get('accepted'), 'job', d.get('job_id') or d.get('wait_id')); print('primary', (d.get('route') or {}).get('primary'))"
JOB="$(echo "$RESP" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('job_id') or d.get('wait_id') or '')")"
if [[ -n "$JOB" ]]; then
  echo "== poll $JOB =="
  for _ in $(seq 1 24); do
    ST="$(curl -fsS -H "Authorization: Bearer $TOKEN" "$CONDUCTOR_URL/v1/jobs/$JOB/status" || true)"
    echo "$ST" | python3 -c "
import sys,json
d=json.load(sys.stdin)
st=d.get('status') or d.get('state')
phase=d.get('phase')
ans=((d.get('result') or {}) if isinstance(d.get('result'), dict) else {})
text=(ans.get('answer') or ans.get('text') or '')
print('status', st, 'phase', phase, 'chars', len(text or ''))
if st in ('done','succeeded','completed','failed','error','cancelled') or phase in ('done','failed','succeeded'):
  print('RESULT', (text or '')[:200])
  raise SystemExit(0)
" && break
    sleep 5
  done
fi
echo "verify_done"
