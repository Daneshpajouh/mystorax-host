#!/usr/bin/env python3
"""Deterministic package contract check; live endpoints remain runtime authority."""
from __future__ import annotations
import json
from pathlib import Path
import re
import sys

root = Path(__file__).resolve().parent.parent
version = (root / "VERSION").read_text().strip()
registry = json.loads((root / "modules.json").read_text())
modules = registry.get("modules") or []
ids = [m["id"] for m in modules]
skill_ids = sorted(p.parent.name for p in (root / "skills").glob("*/SKILL.md"))
errors: list[str] = []
if version != "3.1.0" or registry.get("version") != version:
    errors.append("version mismatch")
if len(ids) != 2 or len(set(ids)) != 2 or sorted(ids) != skill_ids:
    errors.append("module registry must match exactly two skill directories")
for item in modules:
    for field in ("id", "task", "tool", "http"):
        if not item.get(field):
            errors.append(f"{item.get('id')} missing {field}")
for path in root.rglob("*"):
    if not path.is_file() or ".git" in path.parts:
        continue
    text = path.read_text(errors="ignore")
    if re.search(r'(?i)(bearer|token)[=:]["\x27]?[A-Za-z0-9_-]{24,}', text):
        errors.append(f"possible credential literal: {path.relative_to(root)}")
if errors:
    print("\n".join(errors), file=sys.stderr)
    raise SystemExit(1)
print(f"package_contract=PASS version={version} modules={len(ids)}")
