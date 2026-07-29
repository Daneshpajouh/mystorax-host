# HTTP / curl connector (any agent)

Works for every front that can hold a bearer token — no plugin required.

## Env

```bash
export MYSTORAX_CONDUCTOR_URL=https://mx.parallex.ca
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
```

## Discovery

```bash
curl -fsS "$MYSTORAX_CONDUCTOR_URL/health"
curl -fsS "$MYSTORAX_CONDUCTOR_URL/v1/hosts/manifest"
curl -fsS -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  "$MYSTORAX_CONDUCTOR_URL/v1/routing-guide"
curl -fsS -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  "$MYSTORAX_CONDUCTOR_URL/v1/surfaces" | head
```

## Submit goal

```bash
curl -fsS -X POST "$MYSTORAX_CONDUCTOR_URL/v1/goal" \
  -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "text":"Reply with exactly: MYSTORAX_OK",
    "job_class":"research",
    "effort":"low",
    "dispatch":true,
    "host":"custom",
    "async_mode":true
  }'
```

## Poll

```bash
curl -fsS -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  "$MYSTORAX_CONDUCTOR_URL/v1/jobs/$JOB_ID/status"
```

## Wait SSE

```bash
curl -fsS -N -H "Authorization: Bearer $MYSTORAX_HOST_TOKEN" \
  "$MYSTORAX_CONDUCTOR_URL/v1/waits/$WAIT_ID/stream"
```

Pack helper: `./verify.sh` runs health → manifest → routing → submit → poll.
