<!-- ABOUTME: gh-stack (gh stack) command reference for the pr-stacking skill. -->
<!-- ABOUTME: Command mappings, detection, interactive-command flags, and errors. -->

# gh-stack (`gh stack`) Command Reference

The github/gh-stack extension. This is the default stacking tool when a repo isn't graphite-initialized.

## Detecting an Active Stack
Within a git repo, `gh stack view` exits non-zero when the current branch is not part of a stack, and succeeds on a tracked stack. Check its exit code directly (do not pipe — a pipe reports the last command's exit, not `gh stack view`'s). `gh stack view --json` gives machine-readable output if needed.

## Starting Work
| Command | Purpose |
|---|---|
| `gh stack init <branch>` | Start a stack; first branch based on default branch |
| `gh stack init b1 b2 b3` | Create/adopt a multi-layer stack at once |
| `gh stack init --base develop <branch>` | Use a non-default trunk |
| `gh stack add -Am "msg" <branch>` | Add a branch on top, stage all + commit |
| `gh stack add -m "msg"` | Add branch, auto-name from commit message |
| `gh stack add -u <branch>` | Stage tracked changes only |

`-A/--all` stages untracked too; `-u/--update` stages tracked only; `-m/--message` sets the commit message.

## Navigating
`gh stack view` (full view), `gh stack view --short` (compact), `gh stack up`, `gh stack down`, `gh stack top`, `gh stack bottom`, `gh stack trunk`, `gh stack checkout <stack-#|pr-#|pr-url|branch>`.
**Interactive — hand to user:** `gh stack switch` (interactive branch picker), `gh stack checkout` with no argument (interactive picker).

## Submitting
| Command | Purpose |
|---|---|
| `gh stack submit --auto` | Push + create/update PRs, auto-generated titles (non-interactive) |
| `gh stack submit --auto --open` | Same, mark new+existing PRs ready for review |
`--auto` skips the editor (required for agent use); without it, `gh stack submit` opens an interactive single-screen editor — **hand that form to the user.** With `--auto`, new PRs are created as drafts unless `--open` is passed.

## Staying Up to Date
- `gh stack sync` — fetch, reconcile with remote stack, fast-forward trunk, cascade-rebase, push atomically, sync PR state. `--prune` deletes local branches for merged PRs. Prompts interactively on divergence — hand to user if it prompts.
- `gh stack rebase` — cascading rebase across the stack. `--downstack` (trunk→current), `--upstack` (current→top), `--no-trunk` (inter-branch only), `--continue`, `--abort`.

## Restructuring
**Interactive TUI — hand to user:** `gh stack modify` (drop/fold/insert/reorder/rename; apply with Ctrl+S). `--continue` / `--abort` resume or restore a modify session.

## Merging
`gh stack merge` (interactive wizard — hand to user), `gh stack merge <stack-#|pr-#>`, `gh stack merge --yes --squash` (non-interactive, merge whole stack up to given PR).

## Linking / Unstacking
- `gh stack link <branch-or-pr> <branch-or-pr>...` — create/update a GitHub stack from branches/PRs without local tracking (for external tools).
- `gh stack unstack` — remove active stack from local tracking + GitHub; `gh stack unstack <stack-#>`; `gh stack unstack --local` (local only). Alias: `gh stack delete`.

## Resolving a Rebase Conflict
On a conflict, `gh stack sync` restores branches and tells you to run `gh stack rebase`. Then: resolve files → `git add` → `gh stack rebase --continue`; or `gh stack rebase --abort` to restore all branches.

## Interactive Commands (never agent-runnable — require a terminal)
`gh stack submit` (without `--auto`), `gh stack modify`, `gh stack switch`, `gh stack merge` (without `--yes`), `gh stack checkout` (no arg). Hand these to the user.

## Full Documentation
`gh stack --help` and `gh stack <subcommand> --help` for anything not covered here.
