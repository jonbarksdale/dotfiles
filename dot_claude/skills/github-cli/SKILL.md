---
name: github-cli
description: GitHub CLI patterns for PR review and repository context gathering. Use when reviewing pull requests, checking CI status, analyzing commits, or gathering GitHub context. Provides gh command patterns for PRs, issues, reviews, and diffs.
---

# GitHub CLI for PR Review

Use these patterns when working with GitHub pull requests and repositories.

## Essential Commands

```bash
gh pr view <number>              # PR overview
gh pr diff <number>              # File changes
gh pr view <number> --comments   # Discussions
gh pr checks <number>            # CI status
```

## Review Workflow

1. `gh pr view <number>` - Get overview
2. `gh pr diff <number>` - See changes
3. `gh pr view <number> --comments` - Read discussions
4. `gh pr checks <number>` - Verify CI

See [reference.md](./reference.md) for complete command reference and workflows.
