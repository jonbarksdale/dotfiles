---
name: pr-stacking
description: Managing stacked pull requests with either the Graphite CLI (`gt`) or the gh-stack extension (`gh stack`). Use whenever the user mentions stacks, stacked PRs, stacked diffs, `gt`, or `gh stack`, or when creating branches / submitting PRs / navigating between related branches in a collaborative repo — even if no tool is named. Detects which tool the repo uses and defaults to `gh stack` when neither is initialized.
---
<!-- ABOUTME: Tool-neutral skill for managing stacked pull requests. -->
<!-- ABOUTME: Covers the shared mental model; defers exact commands to per-tool references. -->

# Stacked Pull Requests

A **stack** is an ordered chain of branches, each based on the one below it, with trunk (usually `main`) at the bottom. Each branch becomes its own PR that reviewers can read independently, while the tooling keeps the chain rebased and in sync. Two CLIs do this with the same model but different commands: Graphite (`gt`) and gh-stack (`gh stack`).

## Mental Model

- **Trunk**: the base branch (main/master).
- **Stack**: the ordered chain of branches above trunk.
- **Upstack**: branches above the current one (away from trunk).
- **Downstack**: branches below the current one (toward trunk).

When a lower branch changes, everything above it must be rebased onto the new state (Graphite calls this *restack*; gh-stack calls it *rebase*). The tool automates that cascade.

## Tool Selection (deterministic, side-effect-free)

1. **If the user names a tool** (`gt`/Graphite or `gh stack`/gh-stack), use it.
2. **Else if graphite is initialized in the repo**, use `gt`. Detect by reading a file marker — do NOT run a `gt` command to probe:
   - `.git/.graphite_repo_config` exists (present from `gt` init onward), **or**
   - `.git/refs/graphite` exists (appears once branches are tracked).
   - ⚠️ Never probe with `gt log`: in a non-graphite repo it *initializes* Graphite as a side effect, converting a plain repo into a graphite one and corrupting detection.
3. **Else default to `gh stack`** (more ubiquitous; assume it when nothing else is set up).

Once the tool is chosen, open its reference for exact commands:
- Graphite → [references/graphite.md](references/graphite.md)
- gh-stack → [references/gh-stack.md](references/gh-stack.md)

## Workflows (by intent)

For each, run the equivalent command from the active tool's reference.

- **Start a feature stack** — sync trunk, create the first branch/PR, make changes, create the next branch on top, submit the stack.
- **Amend after review** — check out the branch, edit, amend/commit onto it, update the open PRs only (don't create new ones).
- **Sync after trunk moves** — pull trunk, clean up merged branches, cascade-rebase the stack, push.
- **Edit a mid-stack branch** — check out the branch, amend, restack/rebase everything upstack, push updates.
- **Resolve a rebase/restack conflict** — fix the files, `git add` them, continue the operation; or abort to restore the pre-operation state.

## Commit Messages

When a workflow creates a commit, follow the `commit` skill's conventional-commit format for the message — don't invent a separate convention here.

## When NOT to Stack

- Solo/personal repos where PRs aren't part of the workflow — use plain Git.
- A single-commit change that doesn't build on other in-flight work — one branch/PR is enough; no stack needed.
