#!/usr/bin/env python3
from __future__ import annotations
import importlib.util
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location("verify_host", ROOT / "scripts" / "verify_host.py")
verify_host = importlib.util.module_from_spec(spec)
assert spec.loader
spec.loader.exec_module(verify_host)


class ContractTests(unittest.TestCase):
    def test_exact_marker(self) -> None:
        self.assertTrue(verify_host.contains_exact_marker({"answer": "MYSTORAX_OK"}))
        self.assertTrue(verify_host.contains_exact_marker({"answer": "Long explanation.\nMYSTORAX_OK"}))
        self.assertFalse(verify_host.contains_exact_marker({"answer": "prefix MYSTORAX_OK"}))

    def test_exact_modules(self) -> None:
        modules = json.loads((ROOT / "modules.json").read_text())["modules"]
        skills = {p.parent.name for p in (ROOT / "skills").glob("*/SKILL.md")}
        self.assertEqual(16, len(modules))
        self.assertEqual(skills, {m["id"] for m in modules})

    def test_locked_doctrine(self) -> None:
        routing = (ROOT / "skills/mystorax-routing/SKILL.md").read_text()
        hard = (ROOT / "skills/mystorax-hard-refuses/SKILL.md").read_text()
        science = (ROOT / "skills/mystorax-science-os/SKILL.md").read_text()
        heavy = (ROOT / "skills/mystorax-front-heavy-lift/SKILL.md").read_text()
        self.assertIn("gemini → copilot → codex → cursor-agent → claude", routing)
        for word in ("Computer", "ASI", "Spark", "local LLM", "agy"):
            self.assertIn(word, hard)
        self.assertIn("EVIDENCE", science)
        self.assertIn("job_class", heavy)
        self.assertIn("research", heavy)


if __name__ == "__main__":
    unittest.main()
