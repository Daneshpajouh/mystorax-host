#!/usr/bin/env python3
"""Credential-free ownership ledger and conservative Cursor MCP merge."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import stat
import tempfile


def digest_tree(path: Path) -> str:
    h = hashlib.sha256()
    for item in sorted(p for p in path.rglob("*") if p.is_file()):
        rel = item.relative_to(path).as_posix()
        h.update(rel.encode() + b"\0")
        h.update(b"x" if item.stat().st_mode & stat.S_IXUSR else b"-")
        h.update(item.read_bytes())
    return h.hexdigest()


def load(path: Path) -> dict:
    if not path.exists():
        return {"schema": "mystorax.host.install-ownership.v1", "artifacts": {}, "registrations": {}}
    data = json.loads(path.read_text())
    if data.get("schema") != "mystorax.host.install-ownership.v1":
        raise SystemExit("unsupported ownership ledger")
    return data


def save(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    fd, tmp = tempfile.mkstemp(prefix=".ownership.", dir=path.parent)
    try:
        os.fchmod(fd, 0o600)
        with os.fdopen(fd, "w") as out:
            json.dump(data, out, indent=2, sort_keys=True)
            out.write("\n")
        os.replace(tmp, path)
    finally:
        if os.path.exists(tmp):
            os.unlink(tmp)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("own-tree", "own-registration", "merge-cursor", "check", "uninstall"))
    parser.add_argument("--ledger", required=True, type=Path)
    parser.add_argument("--version", required=True)
    parser.add_argument("--front")
    parser.add_argument("--path", type=Path)
    parser.add_argument("--name")
    parser.add_argument("--home", type=Path)
    parser.add_argument("--server")
    parser.add_argument("--url")
    parser.add_argument("--token-file")
    args = parser.parse_args()
    data = load(args.ledger)
    if args.command == "own-tree":
        if not args.path or not args.path.is_dir():
            raise SystemExit("owned tree missing")
        data["artifacts"][str(args.path)] = {
            "front": args.front, "version": args.version, "sha256": digest_tree(args.path)
        }
    elif args.command == "own-registration":
        data["registrations"][args.front] = {
            "name": args.name, "version": args.version, "created_by_installer": True
        }
    elif args.command == "merge-cursor":
        target = args.home / ".cursor" / "mcp.json"
        target.parent.mkdir(parents=True, exist_ok=True)
        current = {"mcpServers": {}}
        if target.exists():
            current = json.loads(target.read_text())
            if not isinstance(current.get("mcpServers", {}), dict):
                raise SystemExit("Cursor MCP config has invalid mcpServers")
        desired = {
            "command": "python3",
            "args": [args.server],
            "env": {
                "MYSTORAX_CONDUCTOR_URL": args.url,
                "MYSTORAX_HOST_TOKEN_FILE": args.token_file,
            },
        }
        existing = current.setdefault("mcpServers", {}).get("mystorax-conductor")
        previously_owned = data["registrations"].get("cursor", {}).get("sha256")
        existing_hash = hashlib.sha256(json.dumps(existing, sort_keys=True).encode()).hexdigest() if existing else None
        legacy_21 = bool(
            isinstance(existing, dict)
            and existing.get("command") == "python3"
            and any(str(arg).endswith("mystorax-host/scripts/conductor_mcp_server.py") for arg in existing.get("args", []))
            and "MYSTORAX_HOST_TOKEN" in (existing.get("env") or {})
        )
        if existing and existing != desired and existing_hash != previously_owned and not legacy_21:
            raise SystemExit("Cursor mystorax-conductor registration is user-owned/conflicting; preserved")
        current["mcpServers"]["mystorax-conductor"] = desired
        fd, tmp = tempfile.mkstemp(prefix=".mcp.", dir=target.parent)
        with os.fdopen(fd, "w") as out:
            json.dump(current, out, indent=2)
            out.write("\n")
        os.replace(tmp, target)
        data["registrations"]["cursor"] = {
            "name": "mystorax-conductor",
            "version": args.version,
            "created_by_installer": existing is None,
            "migrated_from": "2.1.0" if legacy_21 else None,
            "sha256": hashlib.sha256(json.dumps(desired, sort_keys=True).encode()).hexdigest(),
        }
    elif args.command == "check":
        failed = False
        for raw, item in data["artifacts"].items():
            path = Path(raw)
            if not path.is_dir() or digest_tree(path) != item["sha256"]:
                print(f"modified_or_missing={path}")
                failed = True
        if failed:
            return 1
        print(f"ownership=PASS artifacts={len(data['artifacts'])}")
        return 0
    else:
        import shutil
        preserved = 0
        removed = 0
        for raw, item in list(data["artifacts"].items()):
            path = Path(raw)
            if path.is_dir() and digest_tree(path) == item["sha256"]:
                shutil.rmtree(path)
                removed += 1
                del data["artifacts"][raw]
            elif path.exists():
                print(f"preserved_modified={path}")
                preserved += 1
        cursor = data["registrations"].get("cursor")
        if cursor and args.home:
            target = args.home / ".cursor" / "mcp.json"
            if target.is_file():
                current = json.loads(target.read_text())
                existing = (current.get("mcpServers") or {}).get("mystorax-conductor")
                existing_hash = hashlib.sha256(json.dumps(existing, sort_keys=True).encode()).hexdigest() if existing else None
                if existing_hash == cursor.get("sha256"):
                    del current["mcpServers"]["mystorax-conductor"]
                    target.write_text(json.dumps(current, indent=2) + "\n")
                    removed += 1
                    del data["registrations"]["cursor"]
                elif existing:
                    print(f"preserved_modified={target}:mystorax-conductor")
                    preserved += 1
        save(args.ledger, data)
        print(f"uninstall_removed={removed} preserved={preserved}")
        return 0
    save(args.ledger, data)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
