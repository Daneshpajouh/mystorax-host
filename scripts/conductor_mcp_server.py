#!/usr/bin/env python3
"""MystoraX Conductor MCP — stdio JSON-RPC facade over Conductor HTTP only.

Front-agnostic: this process holds NO Science/Axiom tokens and does NOT import
local Conductor modules. Capability lives on Conductor:

  GET  {MYSTORAX_CONDUCTOR_URL}/v1/hosts/mcp/tools
  POST {MYSTORAX_CONDUCTOR_URL}/v1/hosts/mcp/tools/call

Env:
  MYSTORAX_CONDUCTOR_URL   default https://mx.parallex.ca
  MYSTORAX_HOST_TOKEN      Bearer host ingress (writes / axiom proxy)
  MYSTORAX_HOST_TOKEN_FILE optional path; defaults to the existing MystoraX secret

Stdlib only. Any front (Cursor, Claude, Codex, curl) uses the same HTTP SSoT.
"""

from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.request
from typing import Any

SERVER_NAME = "mystorax-conductor"
SERVER_VERSION = "2.2.0"
PROTOCOL_VERSION = "2024-11-05"


def _base_url() -> str:
    return (
        os.environ.get("MYSTORAX_CONDUCTOR_URL")
        or os.environ.get("MYSTORAX_PUBLIC_BASE")
        or "https://mx.parallex.ca"
    ).rstrip("/")


def _host_token() -> str:
    token = (
        os.environ.get("MYSTORAX_HOST_TOKEN")
        or os.environ.get("MYSTORAX_HOST_INGRESS_TOKEN")
        or ""
    ).strip()
    if token:
        return token
    token_file = os.environ.get("MYSTORAX_HOST_TOKEN_FILE")
    if not token_file:
        token_file = os.path.expanduser("~/.mystorax/secrets/host_ingress_token")
    try:
        return open(token_file, encoding="utf-8").read().strip()
    except (OSError, UnicodeError):
        return ""


def _http(
    method: str,
    path: str,
    *,
    body: dict[str, Any] | None = None,
    auth: bool = False,
    timeout: float = 120.0,
) -> dict[str, Any]:
    url = f"{_base_url()}{path if path.startswith('/') else '/' + path}"
    headers = {"Accept": "application/json"}
    data = None
    if body is not None:
        data = json.dumps(body).encode()
        headers["Content-Type"] = "application/json"
    if auth:
        token = _host_token()
        if token:
            headers["Authorization"] = f"Bearer {token}"
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            raw = resp.read().decode() or "{}"
            try:
                return json.loads(raw)
            except json.JSONDecodeError:
                return {"ok": True, "raw": raw[:50000]}
    except urllib.error.HTTPError as exc:
        err: dict[str, Any] = {
            "ok": False,
            "error": f"HTTPError:{exc.code}",
            "url": url,
        }
        try:
            err["body"] = json.loads(exc.read().decode() or "{}")
        except Exception:
            pass
        return err
    except Exception as exc:
        return {"ok": False, "error": f"{type(exc).__name__}:{exc}", "url": url}


def _list_tools() -> list[dict[str, Any]]:
    out = _http("GET", "/v1/hosts/mcp/tools", auth=False)
    tools = out.get("tools") if isinstance(out, dict) else None
    return tools if isinstance(tools, list) else []


def _call_tool(name: str, arguments: dict[str, Any]) -> dict[str, Any]:
    timeout = 120.0
    if name == "mystorax_axiom_tool_call":
        timeout = float(arguments.get("timeout_s") or 120.0) + 10.0
    elif name == "mystorax_science_resume":
        timeout = 910.0
    return _http(
        "POST",
        "/v1/hosts/mcp/tools/call",
        body={"name": name, "arguments": arguments},
        auth=True,
        timeout=timeout,
    )


def _write(msg: dict[str, Any]) -> None:
    sys.stdout.write(json.dumps(msg, default=str) + "\n")
    sys.stdout.flush()


def _result(req_id: Any, result: Any) -> None:
    _write({"jsonrpc": "2.0", "id": req_id, "result": result})


def _error(req_id: Any, code: int, message: str) -> None:
    _write(
        {
            "jsonrpc": "2.0",
            "id": req_id,
            "error": {"code": code, "message": message},
        }
    )


def _handle(msg: dict[str, Any]) -> None:
    method = msg.get("method")
    req_id = msg.get("id")
    params = msg.get("params") if isinstance(msg.get("params"), dict) else {}

    if method == "initialize":
        _result(
            req_id,
            {
                "protocolVersion": PROTOCOL_VERSION,
                "capabilities": {"tools": {}},
                "serverInfo": {"name": SERVER_NAME, "version": SERVER_VERSION},
            },
        )
        return

    if method == "notifications/initialized" or method == "initialized":
        return

    if method == "tools/list":
        _result(req_id, {"tools": _list_tools()})
        return

    if method == "tools/call":
        name = str(params.get("name") or "").strip()
        arguments = (
            params.get("arguments")
            if isinstance(params.get("arguments"), dict)
            else {}
        )
        out = _call_tool(name, arguments)
        text = json.dumps(out, indent=2, default=str)
        _result(
            req_id,
            {
                "content": [{"type": "text", "text": text}],
                "structuredContent": out,
                "isError": bool(isinstance(out, dict) and out.get("ok") is False),
            },
        )
        return

    if method == "ping":
        _result(req_id, {})
        return

    if req_id is not None:
        _error(req_id, -32601, f"method_not_found:{method}")


def main() -> int:
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except json.JSONDecodeError:
            continue
        if not isinstance(msg, dict):
            continue
        _handle(msg)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
