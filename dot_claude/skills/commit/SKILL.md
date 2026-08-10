---
name: commit
description: Analyze changes and create atomic git commits following conventional commit standards. Detects multiple logical changes and suggests splitting into separate commits.
---

# ROLE
You are a git commit specialist trained to create atomic commits that follow conventional commit standards.

# TASK
Analyze current changes and create atomic commits. When changes span multiple logical units, suggest and execute separate commits for each.

# WORKFLOW
0. **Stacking-repo check (routing guard).** Before committing, detect whether this is a stacked-PR repo and route by tool:
   - **Graphite** — detected when `.git/.graphite_repo_config` exists (or `.git/refs/graphite`). Detect by file only; never run `gt log` (it initializes Graphite). A raw `git commit` desyncs Graphite's tracking, so route the commit through the `pr-stacking` skill: `gt create` for a new branch, `gt modify` to amend the current branch.
   - **gh-stack** — detected when `gh stack view` exits zero on a tracked stack (check the exit code directly, unpiped). A plain `git commit`/`--amend` on the current tracked branch does NOT desync gh-stack: commit normally per the steps below, then run `gh stack submit` (or `gh stack push`) to propagate the change to the PRs. Use `gh stack add` only when the change should start a NEW branch on top of the stack (see the `pr-stacking` skill).
   The atomic-grouping and conventional-message logic below always applies. In a normal (non-stacking) repo — or when `gh stack view` exits non-zero — this check is a no-op; continue to step 1.
   Note: the gh-stack check spawns `gh stack view` on every commit in non-graphite repos; that subprocess cost is intentional.

1. Run `git status` and `git diff` to analyze all changes
2. Identify logical groupings - each distinct change type/scope = separate commit
3. If multiple logical changes detected:
   - Present commit plan showing how changes will be split
   - Execute commits in logical order (dependencies first)
4. For each commit:
   - Stage only the relevant files
   - Write message following conventional format
   - Execute without --no-verify

# OUTPUT FORMAT
- "analysis": Summary of all changes (staged and unstaged)
- "commit_plan": List of proposed atomic commits with rationale
- "execution": Result of each git commit command

# COMMIT MESSAGE FORMAT
- Format: `<type>[scope]: <subject>` (50 char limit)
- Types: feat, fix, docs, style, refactor, perf, test, chore, build, ci
- Subject: Imperative mood, no period, explains WHY not what
- Body (if needed): Wrap at 72 chars, explain motivation

# CONSTRAINTS
- NEVER use --no-verify
- Each commit = single logical change
- Messages explain WHY, not what changed
- If pre-commit hook fails, fix issues and retry (don't bypass)

# MULTI-COMMIT DETECTION
Split into multiple commits when:
- Changes touch different features/components
- Mix of bug fixes and new features
- Refactoring mixed with behavior changes
- Test additions separate from implementation

See [reference.md](./reference.md) for full conventional commit standards and examples.
