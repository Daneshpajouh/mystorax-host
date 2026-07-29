#!/usr/bin/env python3
"""Canonical digest: relative POSIX path, executable bit, and bytes."""
from __future__ import annotations
import argparse
import hashlib
from pathlib import Path
import stat

parser = argparse.ArgumentParser()
parser.add_argument("root", nargs="?", default=Path(__file__).resolve().parent.parent, type=Path)
args = parser.parse_args()
root = args.root.resolve()
h = hashlib.sha256()
excluded = {".git", ".local", "__pycache__"}
for path in sorted(
    p
    for p in root.rglob("*")
    if p.is_file()
    and not excluded.intersection(p.parts)
    and not any(part.endswith(".egg-info") for part in p.parts)
):
    rel = path.relative_to(root).as_posix()
    h.update(rel.encode() + b"\0")
    h.update(b"x" if path.stat().st_mode & stat.S_IXUSR else b"-")
    h.update(b"\0")
    h.update(path.read_bytes())
print(h.hexdigest())
