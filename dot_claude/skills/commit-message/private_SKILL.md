---
name: commit-message
description: Git commit message standards using Conventional Commits format. Use when creating git commits, reviewing commit messages, or writing changelog entries. Covers type prefixes (feat, fix, docs, etc.), formatting rules, and breaking change notation.
---

# Commit Message Standards

Apply these standards when creating or reviewing git commits.

## Quick Reference

**Format**: `<type>[scope]: <subject>` (50 char limit)

**Types**: feat, fix, docs, style, refactor, perf, test, chore, build, ci

**Key Rules**:
- Imperative mood ("Add feature" not "Added feature")
- No period at end of subject
- Body explains what/why, not how

**Breaking Changes**: Use `!` suffix or `BREAKING CHANGE:` footer

See [reference.md](./reference.md) for full standards and examples.
