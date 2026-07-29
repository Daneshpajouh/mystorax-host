# Codex (ChatGPT desktop → Codex mode)

## Why you could not see it

Copying files into `~/.codex/plugins/local/` is **not** enough for the app Plugins panel.
The Codex / ChatGPT desktop app only lists **marketplace** plugins (e.g. `mystorax-host@personal`).

## Install (makes it visible)

```bash
cd mystorax-host   # or: ~/mystorax-host on MacBook
./setup.sh --front codex
```

That now:
1. Syncs skills + local pack
2. Registers **Personal → MystoraX** (`mystorax-host@personal`)
3. Enables MCP `mystorax-conductor`

Confirm:

```bash
codex plugin list | grep mystorax
# mystorax-host@personal  installed, enabled  2.3.1  ...
```

## In the app

1. Open **ChatGPT desktop** → switcher → **Codex** (or Work), not plain Chat
2. Open **Plugins**
3. Find **MystoraX** under **Personal** (enabled)
4. New chat → ask: “Use MystoraX to research …”
   - or type `@` and pick MystoraX if the picker is available
5. Tools come from MCP `mystorax-conductor` (`mystorax_submit_goal`, etc.)

Also works from terminal: `mx "your question"`

## ChatGPT plain Chat (no Codex)

Local plugins do **not** appear there. Use Custom GPT **Actions** with  
`https://mx.parallex.ca/v1/hosts/chatgpt/openapi.yaml` + Bearer host token.
