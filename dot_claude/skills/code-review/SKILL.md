---
name: code-review
description: Code review standards for quality, security, and maintainability. Auto-triggers during PR reviews and code analysis.
---

# Code Review Standards

Apply when reviewing code changes, PRs, or refactoring.

## Quick Reference

**Quality Checks**:
- Single Responsibility: Does each function/class do one thing?
- Naming: Are names descriptive and intention-revealing?
- Complexity: Can this be simplified without losing clarity?

**Security Checks**:
- Input validation at system boundaries
- No hardcoded secrets or credentials
- OWASP Top 10 awareness (injection, XSS, auth issues)

**Maintainability**:
- Matches surrounding code style
- Comments explain WHY, not WHAT
- No premature abstraction

See [reference.md](./reference.md) for detailed checklist.
