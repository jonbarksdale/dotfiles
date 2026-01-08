---
name: python
description: Python development standards including project structure, quality tools (uv, ruff, mypy, pytest), testing patterns, and best practices.
---

# Python Development Standards

Apply these standards when working with Python projects.

## Toolchain Summary

| Category | Tool |
|----------|------|
| Package Manager | uv |
| Linting/Formatting | ruff |
| Type Checking | mypy (strict) |
| Testing | pytest + pytest-cov |

## Key Commands

```bash
uv sync                           # Install dependencies
uv run ruff format . && ruff check .  # Format and lint
uv run mypy .                     # Type check
uv run pytest --cov=src           # Test with coverage
```

## Quality Requirements

- 90% minimum test coverage
- Strict PEP 8 compliance
- 100% type annotation coverage
- Python 3.11+ with modern patterns

See [reference.md](./reference.md) for complete tooling standards and configurations.
