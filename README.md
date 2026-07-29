# mystorax-host

Talk to MystoraX from this Mac in **two commands**.

## Install

```bash
git clone https://github.com/Daneshpajouh/mystorax-host.git
cd mystorax-host
./setup.sh --token PASTE_YOUR_HOST_TOKEN
```

Already have `~/.mystorax/secrets/host_ingress_token`?

```bash
./setup.sh
```

## Use

```bash
mx "Your research or planning question"
mx status <job_id>
```

Reload Cursor / Claude Code / Codex once. After that, just ask the agent — MystoraX is wired in.

## That’s it

| Need | Command |
|------|---------|
| Install | `./setup.sh` |
| Ask | `mx "…"` |
| Job status | `mx status <job_id>` |
| Uninstall | `./uninstall.sh` |
