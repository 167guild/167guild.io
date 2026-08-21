#!/usr/bin/env python3
"""Reject non-synthetic identity fixtures in public authorization surfaces."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SENSITIVE_PATHS = (
    Path("docs/authorization.md"),
    Path("docs/setup/deployment.md"),
    Path("deploy/README.md"),
    Path("scripts/bootstrap/seed-groups.sql"),
    Path("audits/2026-06-27-reflector-sync.md"),
    Path("audits/oss/oss-readiness.md"),
)
RESERVED_DOMAINS = {"example.com", "example.net", "example.org", "example.invalid"}
EMAIL_PATTERN = re.compile(
    r"(?<![A-Za-z0-9._%+-])"
    r"([A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,})"
)
ROSTER_PATTERNS = (
    re.compile(r"initial\s+(?:placeholder\s+)?members?", re.IGNORECASE),
    re.compile(r"replace\s+with\s+.+?actual\s+(?:google\s+)?account", re.IGNORECASE),
    re.compile(r"confirmed\s+and\s+does\s+not\s+require\s+a\s+placeholder", re.IGNORECASE),
)


def main() -> int:
    errors: list[str] = []

    for relative_path in SENSITIVE_PATHS:
        path = ROOT / relative_path
        if not path.is_file():
            errors.append(f"{relative_path}: required privacy surface is missing")
            continue

        text = path.read_text(encoding="utf-8")

        for match in EMAIL_PATTERN.finditer(text):
            address = match.group(1)
            domain = address.rsplit("@", 1)[1].lower()
            if domain not in RESERVED_DOMAINS:
                line = text.count("\n", 0, match.start()) + 1
                errors.append(
                    f"{relative_path}:{line}: non-synthetic email fixture ({domain})"
                )

        for pattern in ROSTER_PATTERNS:
            match = pattern.search(text)
            if match:
                line = text.count("\n", 0, match.start()) + 1
                errors.append(
                    f"{relative_path}:{line}: identity-specific roster instruction"
                )

    if errors:
        print("Public fixture verification failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    print("Public identity fixtures are synthetic and role-based.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
