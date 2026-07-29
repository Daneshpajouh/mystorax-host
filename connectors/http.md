# HTTP

```bash
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
# easiest: use the pack CLI
./mx "your question"
./mx status <job_id>
```

Raw curl: `POST https://mx.parallex.ca/v1/goal` with Bearer token, `job_class=research`, `dispatch=true`, `async_mode=true`.
