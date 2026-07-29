# Quick onboard

## Mac (Cursor / Claude Code / Codex)

```bash
git clone https://github.com/Daneshpajouh/mystorax-host.git && cd mystorax-host
./setup.sh --token PASTE_YOUR_HOST_TOKEN
# reload Cursor / Claude Code / Codex once
./mx "Reply with exactly: MYSTORAX_OK"
```

## Claude Science

1. Import GitHub pack `Daneshpajouh/mystorax-host`
2. Set env `MYSTORAX_HOST_TOKEN` (same token)
3. Base URL `https://mx.parallex.ca`
4. Call routing → surfaces → submit goal (`job_class=research` for heavy lift)

## ChatGPT Actions

1. Import `https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml`
2. Auth: Bearer host token
3. `submitGoal`

## Curl

```bash
export MYSTORAX_HOST_TOKEN="$(cat ~/.mystorax/secrets/host_ingress_token)"
./mx "your question"   # from a local pack checkout
```

Token file path: `~/.mystorax/secrets/host_ingress_token`  
Never paste the token into git or chat logs.
