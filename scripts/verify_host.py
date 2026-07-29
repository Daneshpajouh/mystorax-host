#!/usr/bin/env python3
"""Strict live MystoraX host smoke with redacted structured evidence."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import sys
import time
import urllib.error
import urllib.request

MARKER = "MYSTORAX_OK"
TERMINAL_OK = {"done", "succeeded", "completed", "success"}
TERMINAL_BAD = {"failed", "error", "cancelled", "canceled", "refused"}


def token() -> str:
    direct = os.environ.get("MYSTORAX_HOST_TOKEN", "").strip()
    if direct:
        return direct
    path = Path(os.environ.get("MYSTORAX_HOST_TOKEN_FILE", "~/.mystorax/secrets/host_ingress_token")).expanduser()
    try:
        return path.read_text().strip()
    except OSError:
        return ""


def call(base: str, method: str, path: str, bearer: str = "", body: dict | None = None) -> dict:
    headers = {"Accept": "application/json"}
    data = None
    if bearer:
        headers["Authorization"] = f"Bearer {bearer}"
    if body is not None:
        headers["Content-Type"] = "application/json"
        data = json.dumps(body).encode()
    request = urllib.request.Request(base + path, headers=headers, data=data, method=method)
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.loads(response.read())


def contains_exact_marker(value: object) -> bool:
    if isinstance(value, str):
        return any(line.strip() == MARKER for line in value.splitlines())
    if isinstance(value, dict):
        return any(contains_exact_marker(v) for v in value.values())
    if isinstance(value, list):
        return any(contains_exact_marker(v) for v in value)
    return False


def fail(message: str, code: int = 1) -> int:
    state = "NOT_RUN" if code == 3 else "FAILED"
    print(json.dumps({"result": state, "error": message}, sort_keys=True))
    return code


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", default=os.environ.get("MYSTORAX_CONDUCTOR_URL", "https://mx.parallex.ca"))
    parser.add_argument("--timeout", type=int, default=180)
    parser.add_argument(
        "--terminal",
        action="store_true",
        help="also require a successful terminal result with MYSTORAX_OK on its own line",
    )
    args = parser.parse_args()
    base = args.url.rstrip("/")
    bearer = token()
    if not bearer:
        return fail("host token unavailable", 3)
    try:
        health = call(base, "GET", "/health")
        if not isinstance(health, dict) or not (
            health.get("status") in {"ok", "healthy"} or health.get("ok") is True
        ):
            return fail("health schema/status invalid")
        manifest = call(base, "GET", "/v1/hosts/manifest")
        mcp = manifest.get("conductor_mcp") or {}
        if manifest.get("doctrine_version") != "mystorax.front_agnostic.v1":
            return fail("doctrine mismatch")
        if int(mcp.get("tool_count") or 0) != 10:
            return fail("MCP tool count mismatch")
        routing = call(base, "GET", "/v1/routing-guide", bearer)
        if routing.get("hands_order") != ["gemini", "copilot", "codex", "cursor-agent", "claude"]:
            return fail("Hands order mismatch")
        if routing.get("science_max_auto_phase") != "EVIDENCE":
            return fail("Science stop mismatch")
        surfaces = call(base, "GET", "/v1/surfaces", bearer)
        if not isinstance(surfaces, dict):
            return fail("surfaces response invalid")
        submitted = call(base, "POST", "/v1/goal", bearer, {
            "text": (
                "Non-actioning host-package verification. Write one short sentence confirming "
                "the Conductor route, at least 80 characters total, then put MYSTORAX_OK alone "
                "on the final line."
            ),
            "job_class": "research",
            "effort": "low",
            "dispatch": True,
            "async_mode": True,
            "host": "custom",
            "metadata": {"prefer": "perplexity", "verification_fixture": "mystorax-host"},
            "bridge_opts": {"sources": ["web"], "mode": "concise"},
        })
        job = submitted.get("job_id") or submitted.get("wait_id")
        if not submitted.get("accepted") or not job:
            return fail("goal not accepted or missing receipt")
        if not args.terminal:
            print(json.dumps({
                "result": "PASS",
                "smoke_scope": "accepted",
                "job_id": job,
                "doctrine": manifest.get("doctrine_version"),
                "manifest_version": manifest.get("manifest_version"),
                "mcp_tools": mcp.get("tool_count"),
            }, sort_keys=True))
            print("verify_done")
            return 0
        deadline = time.monotonic() + args.timeout
        while time.monotonic() < deadline:
            status = call(base, "GET", f"/v1/jobs/{job}/status", bearer)
            state = str(status.get("status") or status.get("state") or status.get("phase") or "").lower()
            if state in TERMINAL_BAD:
                return fail(f"goal terminal state {state}")
            if state in TERMINAL_OK:
                if not contains_exact_marker(status.get("result")):
                    return fail("terminal result missing exact marker")
                print(json.dumps({
                    "result": "PASS",
                    "job_id": job,
                    "doctrine": manifest.get("doctrine_version"),
                    "manifest_version": manifest.get("manifest_version"),
                    "mcp_tools": mcp.get("tool_count"),
                    "marker": MARKER,
                }, sort_keys=True))
                print("verify_done")
                return 0
            time.sleep(3)
        return fail("goal verification timed out")
    except (urllib.error.URLError, TimeoutError, json.JSONDecodeError, KeyError, ValueError) as exc:
        return fail(f"{type(exc).__name__}")


if __name__ == "__main__":
    raise SystemExit(main())
