#!/usr/bin/env python3
"""Thin MystoraX Conductor stdio MCP facade.

The server contains no routing engine and no bridge credentials. It maps MCP
tools to the public Conductor HTTP source of truth.

Environment:
    MYSTORAX_CONDUCTOR_URL       default: https://mx.parallex.ca
    MYSTORAX_HOST_TOKEN          Bearer token for authenticated calls
    MYSTORAX_HOST_INGRESS_TOKEN  compatible token alias
    MYSTORAX_HTTP_TIMEOUT_S      default request timeout
"""

from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request
from typing import Any

SERVER_NAME = "mystorax-conductor"
SERVER_VERSION = "2.0.1"
PROTOCOL_VERSION = "2024-11-05"
DEFAULT_BASE = "https://mx.parallex.ca"

TOOL_DESCRIPTORS: list[dict[str, Any]] = [
    {
        "name": "mystorax_routing_guide",
        "description": (
            "Fetch current MystoraX routing doctrine. Call before selecting "
            "authors, Hands, sources, Science OS paths, or fallbacks."
        ),
        "inputSchema": {"type": "object", "properties": {}},
    },
    {
        "name": "mystorax_surfaces",
        "description": (
            "List capability surfaces and statuses. Optional status filter: "
            "wired, guided, inventory, refused, or deferred."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {"status": {"type": "string"}},
        },
    },
    {
        "name": "mystorax_capability_lookup",
        "description": "Find capability surfaces by ID, plane, or description.",
        "inputSchema": {
            "type": "object",
            "properties": {"query": {"type": "string"}},
            "required": ["query"],
        },
    },
    {
        "name": "mystorax_submit_goal",
        "description": (
            "Submit a goal through POST /v1/goal. Preserve bridge_opts, metadata, "
            "durable IDs, evidence, costs, and gate states."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {
                "text": {"type": "string"},
                "host": {"type": "string", "default": "mcp_gateway"},
                "voice": {"type": "boolean", "default": False},
                "job_class": {
                    "type": "string",
                    "enum": [
                        "research",
                        "coding",
                        "planning",
                        "science",
                        "ops",
                        "voice_frontdoor",
                    ],
                },
                "effort": {
                    "type": "string",
                    "enum": ["low", "medium", "high", "xhigh"],
                },
                "worker": {"type": "string"},
                "model": {"type": "string"},
                "mode": {},
                "bridge_opts": {"type": "object"},
                "metadata": {"type": "object"},
                "dispatch": {"type": "boolean", "default": True},
                "async_mode": {"type": "boolean"},
            },
            "required": ["text"],
        },
    },
    {
        "name": "mystorax_job_status",
        "description": "Get durable job status by job_id.",
        "inputSchema": {
            "type": "object",
            "properties": {"job_id": {"type": "string"}},
            "required": ["job_id"],
        },
    },
    {
        "name": "mystorax_wait_stream_hint",
        "description": (
            "Return durable job-poll and SSE wait URLs. Use instead of keeping a "
            "model or CLI busy solely to wait."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {"wait_id": {"type": "string"}},
        },
    },
    {
        "name": "mystorax_science_status",
        "description": "Get Science OS and Axiom readiness from Conductor.",
        "inputSchema": {"type": "object", "properties": {}},
    },
    {
        "name": "mystorax_science_resume",
        "description": (
            "Resume a bounded Science OS campaign. Automatic progression may not "
            "pass EVIDENCE and never auto-CERTIFY."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {
                "campaign_id": {"type": "string"},
                "goal": {"type": "string"},
                "phase": {"type": "string"},
                "max_phases": {"type": "integer", "default": 1},
                "max_auto_phase": {
                    "type": "string",
                    "default": "EVIDENCE",
                },
                "effort": {"type": "string"},
                "via": {"type": "string", "default": "cookie"},
            },
            "required": ["campaign_id", "goal"],
        },
    },
    {
        "name": "mystorax_axiom_tool_search",
        "description": (
            "Search the current allowlisted Axiom tool facade through Conductor. "
            "The full biological catalog is not copied into the front."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {"query": {"type": "string"}},
        },
    },
    {
        "name": "mystorax_axiom_tool_call",
        "description": (
            "Call one allowlisted Axiom tool through Conductor. Fails closed when "
            "the Conductor-side credential is unavailable."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {
                "tool": {"type": "string"},
                "arguments": {"type": "object"},
                "timeout_s": {"type": "number"},
            },
            "required": ["tool"],
        },
    },
]


def _base_url() -> str:
    return (os.environ.get("MYSTORAX_CONDUCTOR_URL") or DEFAULT_BASE).rstrip("/")


def _token() -> str:
    return (
        os.environ.get("MYSTORAX_HOST_TOKEN")
        or os.environ.get("MYSTORAX_HOST_INGRESS_TOKEN")
        or ""
    ).strip()


def _timeout(default: float = 60.0) -> float:
    raw = (os.environ.get("MYSTORAX_HTTP_TIMEOUT_S") or "").strip()
    if not raw:
        return default
    try:
        return max(0.2, float(raw))
    except ValueError:
        return default


def _http(
    method: str,
    path: str,
    *,
    body: dict[str, Any] | None = None,
    auth: bool = False,
    timeout: float | None = None,
) -> dict[str, Any]:
    if auth and not _token():
        return {
            "ok": False,
            "error": "MYSTORAX_HOST_TOKEN_required",
            "gate_status": "credential_missing",
        }

    url = f"{_base_url()}{path if path.startswith('/') else '/' + path}"
    headers = {
        "Accept": "application/json",
        "User-Agent": f"{SERVER_NAME}/{SERVER_VERSION}",
    }
    data = None
    if body is not None:
        data = json.dumps(body, separators=(",", ":")).encode("utf-8")
        headers["Content-Type"] = "application/json"
    if auth:
        headers["Authorization"] = f"Bearer {_token()}"

    request = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(
            request, timeout=timeout if timeout is not None else _timeout()
        ) as response:
            raw = response.read().decode("utf-8", "replace")
            if not raw:
                return {"ok": True, "http_status": response.status}
            try:
                payload = json.loads(raw)
            except json.JSONDecodeError:
                return {
                    "ok": 200 <= response.status < 300,
                    "http_status": response.status,
                    "raw": raw[:50000],
                }
            if isinstance(payload, dict):
                payload.setdefault("http_status", response.status)
                return payload
            return {
                "ok": 200 <= response.status < 300,
                "http_status": response.status,
                "data": payload,
            }
    except urllib.error.HTTPError as exc:
        raw = exc.read().decode("utf-8", "replace")
        try:
            payload: Any = json.loads(raw) if raw else {}
        except json.JSONDecodeError:
            payload = {"raw": raw[:50000]}
        return {
            "ok": False,
            "error": f"HTTP_{exc.code}",
            "http_status": exc.code,
            "url": url,
            "body": payload,
        }
    except Exception as exc:
        return {
            "ok": False,
            "error": f"{type(exc).__name__}:{exc}",
            "url": url,
        }


def _surfaces(arguments: dict[str, Any]) -> dict[str, Any]:
    result = _http("GET", "/v1/surfaces")
    status = str(arguments.get("status") or "").strip().lower()
    if status and isinstance(result.get("surfaces"), list):
        result = {
            **result,
            "surfaces": [
                item
                for item in result["surfaces"]
                if str(item.get("status") or "").lower() == status
            ],
            "filtered_status": status,
        }
    return result


def _capability_lookup(arguments: dict[str, Any]) -> dict[str, Any]:
    query = str(arguments.get("query") or "").strip().lower()
    if not query:
        return {"ok": False, "error": "query_required"}
    snapshot = _http("GET", "/v1/surfaces")
    if not isinstance(snapshot.get("surfaces"), list):
        return snapshot
    hits = []
    for item in snapshot["surfaces"]:
        haystack = " ".join(
            str(item.get(key) or "") for key in ("id", "plane", "how", "status")
        ).lower()
        if query in haystack:
            hits.append(item)
    return {
        "ok": True,
        "query": query,
        "count": len(hits),
        "hits": hits[:100],
        "hard_refused_hint": [
            item for item in hits if item.get("status") == "refused"
        ][:25],
    }


def _submit_goal(arguments: dict[str, Any]) -> dict[str, Any]:
    text = str(arguments.get("text") or "").strip()
    if not text:
        return {"ok": False, "error": "text_required"}

    allowed = (
        "host",
        "voice",
        "job_class",
        "effort",
        "worker",
        "model",
        "mode",
        "bridge_opts",
        "metadata",
        "dispatch",
        "async_mode",
    )
    body: dict[str, Any] = {
        "text": text,
        "host": str(arguments.get("host") or "mcp_gateway"),
        "job_class": str(arguments.get("job_class") or "research"),
        "dispatch": bool(arguments.get("dispatch", True)),
    }
    for key in allowed:
        if key in arguments and arguments[key] is not None:
            body[key] = arguments[key]
    return _http("POST", "/v1/goal", body=body, auth=True, timeout=_timeout(120.0))


def _job_status(arguments: dict[str, Any]) -> dict[str, Any]:
    job_id = str(arguments.get("job_id") or "").strip()
    if not job_id:
        return {"ok": False, "error": "job_id_required"}
    quoted = urllib.parse.quote(job_id, safe="")
    return _http("GET", f"/v1/jobs/{quoted}/status", auth=True)


def _wait_hint(arguments: dict[str, Any]) -> dict[str, Any]:
    wait_id = str(arguments.get("wait_id") or "{wait_id}").strip()
    quoted = urllib.parse.quote(wait_id, safe="{}")
    return {
        "ok": True,
        "schema": "mystorax.wait_stream_hint.v1",
        "poll": f"GET {_base_url()}/v1/jobs/{quoted}/status",
        "sse": f"GET {_base_url()}/v1/waits/{quoted}/stream",
        "note": "Prefer SSE or bounded status polling over a token-burning local wait.",
    }


def _science_resume(arguments: dict[str, Any]) -> dict[str, Any]:
    campaign_id = str(arguments.get("campaign_id") or "").strip()
    goal = str(arguments.get("goal") or "").strip()
    if not campaign_id or not goal:
        return {"ok": False, "error": "campaign_id_and_goal_required"}

    requested_phase = str(arguments.get("max_auto_phase") or "EVIDENCE").upper()
    allowed_auto = {"DEFINE", "PLAN", "DESIGN", "EXECUTE", "ANALYZE", "EVIDENCE"}
    if requested_phase not in allowed_auto:
        return {
            "ok": False,
            "error": "max_auto_phase_must_not_pass_EVIDENCE",
            "gate_status": "never_auto_certify",
        }

    body: dict[str, Any] = {
        "goal": goal,
        "max_phases": max(1, int(arguments.get("max_phases") or 1)),
        "max_auto_phase": requested_phase,
        "via": str(arguments.get("via") or "cookie"),
    }
    for key in ("phase", "effort"):
        if arguments.get(key) is not None:
            body[key] = arguments[key]
    quoted = urllib.parse.quote(campaign_id, safe="")
    return _http(
        "POST",
        f"/v1/axiom/campaigns/{quoted}/resume",
        body=body,
        auth=True,
        timeout=_timeout(900.0),
    )


def _remote_tool_call(name: str, arguments: dict[str, Any]) -> dict[str, Any]:
    return _http(
        "POST",
        "/v1/hosts/mcp/tools/call",
        body={"name": name, "arguments": arguments},
        auth=True,
        timeout=_timeout(120.0),
    )


def dispatch_tool(name: str, arguments: dict[str, Any]) -> dict[str, Any]:
    if name == "mystorax_routing_guide":
        return _http("GET", "/v1/routing-guide")
    if name == "mystorax_surfaces":
        return _surfaces(arguments)
    if name == "mystorax_capability_lookup":
        return _capability_lookup(arguments)
    if name == "mystorax_submit_goal":
        return _submit_goal(arguments)
    if name == "mystorax_job_status":
        return _job_status(arguments)
    if name == "mystorax_wait_stream_hint":
        return _wait_hint(arguments)
    if name == "mystorax_science_status":
        return _http("GET", "/v1/axiom/status")
    if name == "mystorax_science_resume":
        return _science_resume(arguments)
    if name == "mystorax_axiom_tool_search":
        return _remote_tool_call(name, arguments)
    if name == "mystorax_axiom_tool_call":
        tool = str(arguments.get("tool") or "").strip()
        if not tool:
            return {"ok": False, "error": "tool_required"}
        timeout_s = float(arguments.get("timeout_s") or 60.0)
        return _http(
            "POST",
            "/v1/axiom/mcp/tools/call",
            body={
                "tool": tool,
                "arguments": arguments.get("arguments")
                if isinstance(arguments.get("arguments"), dict)
                else {},
                "timeout_s": timeout_s,
            },
            auth=True,
            timeout=timeout_s + 5.0,
        )
    return {"ok": False, "error": "unknown_tool", "tool": name}


def live_tool_descriptors() -> list[dict[str, Any]]:
    result = _http("GET", "/v1/hosts/mcp/tools", timeout=min(_timeout(), 10.0))
    tools = result.get("tools")
    if isinstance(tools, list) and tools:
        return tools
    return TOOL_DESCRIPTORS


def _write(message: dict[str, Any]) -> None:
    sys.stdout.write(json.dumps(message, separators=(",", ":"), default=str) + "\n")
    sys.stdout.flush()


def _result(request_id: Any, result: Any) -> None:
    _write({"jsonrpc": "2.0", "id": request_id, "result": result})


def _error(request_id: Any, code: int, message: str) -> None:
    _write(
        {
            "jsonrpc": "2.0",
            "id": request_id,
            "error": {"code": code, "message": message},
        }
    )


def _handle(message: dict[str, Any]) -> None:
    method = message.get("method")
    request_id = message.get("id")
    params = message.get("params") if isinstance(message.get("params"), dict) else {}

    if method == "initialize":
        _result(
            request_id,
            {
                "protocolVersion": PROTOCOL_VERSION,
                "capabilities": {"tools": {}},
                "serverInfo": {"name": SERVER_NAME, "version": SERVER_VERSION},
            },
        )
        return

    if method in {"notifications/initialized", "initialized"}:
        return

    if method == "tools/list":
        _result(request_id, {"tools": live_tool_descriptors()})
        return

    if method == "tools/call":
        name = str(params.get("name") or "").strip()
        arguments = (
            params.get("arguments")
            if isinstance(params.get("arguments"), dict)
            else {}
        )
        try:
            output = dispatch_tool(name, arguments)
        except Exception as exc:
            output = {
                "ok": False,
                "error": f"{type(exc).__name__}:{exc}",
                "gate_status": "client_fail_closed",
            }
        _result(
            request_id,
            {
                "content": [
                    {
                        "type": "text",
                        "text": json.dumps(output, indent=2, default=str),
                    }
                ],
                "structuredContent": output,
                "isError": bool(output.get("ok") is False),
            },
        )
        return

    if method == "ping":
        _result(request_id, {})
        return

    if request_id is not None:
        _error(request_id, -32601, f"method_not_found:{method}")


def main() -> int:
    for raw_line in sys.stdin:
        line = raw_line.strip()
        if not line:
            continue
        try:
            message = json.loads(line)
        except json.JSONDecodeError:
            continue
        if isinstance(message, dict):
            _handle(message)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
