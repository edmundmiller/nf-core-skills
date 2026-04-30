#!/usr/bin/env python3
"""Validate SKILL.md files against the Agent Skills specification.

https://agentskills.io/specification
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.stderr.write("PyYAML is required: pip install pyyaml\n")
    sys.exit(2)

NAME_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
ALLOWED_FIELDS = {
    "name",
    "description",
    "license",
    "compatibility",
    "metadata",
    "allowed-tools",
}


def fail(path: Path, msg: str) -> None:
    print(f"{path}: {msg}", file=sys.stderr)


def validate(path: Path) -> bool:
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        fail(path, "missing YAML frontmatter (must start with '---')")
        return False

    end = text.find("\n---", 4)
    if end == -1:
        fail(path, "frontmatter not terminated with '---'")
        return False

    try:
        meta = yaml.safe_load(text[4:end]) or {}
    except yaml.YAMLError as exc:
        fail(path, f"invalid YAML: {exc}")
        return False

    ok = True
    unknown = set(meta) - ALLOWED_FIELDS
    if unknown:
        fail(path, f"unknown frontmatter fields: {sorted(unknown)}")
        ok = False

    name = meta.get("name")
    if not name:
        fail(path, "missing required field 'name'")
        ok = False
    else:
        if len(name) > 64 or not NAME_RE.match(name):
            fail(path, f"invalid name '{name}' (lowercase, hyphens, ≤64 chars)")
            ok = False
        if name != path.parent.name:
            fail(path, f"name '{name}' must match parent directory '{path.parent.name}'")
            ok = False

    desc = meta.get("description")
    if not desc:
        fail(path, "missing required field 'description'")
        ok = False
    elif len(desc) > 1024:
        fail(path, f"description too long ({len(desc)} > 1024)")
        ok = False

    compat = meta.get("compatibility")
    if compat is not None and len(compat) > 500:
        fail(path, f"compatibility too long ({len(compat)} > 500)")
        ok = False

    return ok


def main(argv: list[str]) -> int:
    paths = [Path(p) for p in argv[1:]] or list(Path("skills").glob("*/SKILL.md"))
    ok = all(validate(p) for p in paths)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
