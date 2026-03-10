---
name: github-cli
description: GitHub CLI (gh) patterns for PR review, issue management, and repository context. Use whenever working with pull requests, reviewing PRs, checking CI/CD status, analyzing commits, viewing GitHub issues, or when the user provides a GitHub URL or PR number. Triggers on any gh command usage, PR review workflow, or GitHub repository interaction.
---

# GitHub CLI for PR Review

Use `gh` CLI for all GitHub interactions — PRs, issues, checks, and repo context.

## Essential Commands

```bash
gh pr view <number>              # PR overview
gh pr diff <number>              # File changes
gh pr view <number> --comments   # Discussions
gh pr checks <number>            # CI status
gh issue view <number>           # Issue details
gh api repos/{owner}/{repo}/pulls/{number}/comments  # Inline review comments
```

## PR Review Workflow

1. `gh pr view <number>` — Get overview, description, author
2. `gh pr diff <number>` — See all file changes
3. `gh pr view <number> --comments` — Read discussion threads
4. `gh pr checks <number>` — Verify CI passes
5. Read changed files locally for deeper analysis

## Deep Dive Analysis

```bash
gh pr checkout <number>                          # Check out locally
gh pr view <number> --json commits               # Commit structure
gh pr view <number> --json reviewRequests,reviews # Review status
gh pr view <number> --json mergeable,mergeStateStatus  # Merge readiness
gh pr view <number> --json files                 # List changed files
```

## Context Gathering

```bash
# Find linked issues from PR body
gh pr view <number> --json body | grep -o "#[0-9]*"

# View a referenced issue
gh issue view <issue-number>

# Search related PRs
gh search prs --repo owner/repo "keyword"

# Branch info
gh pr view <number> --json baseRefName,headRefName
```

## Common JSON Fields

Use `--json` for structured data: `title`, `body`, `state`, `author`, `url`, `commits`, `reviews`, `files`, `reviewRequests`, `mergeable`, `mergeStateStatus`, `milestone`, `projectCards`.

See [reference.md](./reference.md) for complete command reference and advanced workflows.
