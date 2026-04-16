---
name: graphite
description: Graphite CLI (gt) patterns for managing stacked pull requests. Use whenever the user mentions graphite, the `gt` command, PR stacks, or stacked diffs. Also triggers when starting development work in a repository where graphite is initialized (`.git/refs/graphite` exists or `gt` commands have been used). Invoke proactively when the user is creating branches, submitting PRs, or navigating between related branches in a collaborative repo — even if they don't mention graphite by name.
---

# Graphite CLI for Stacked PRs

Graphite (`gt`) is a CLI for managing stacked pull requests — chains of dependent branches where each PR builds on the previous one. It automates the rebasing, syncing, and PR creation that vanilla Git makes painful.

## Detecting Graphite in a Repo

Graphite is initialized if `.git/refs/graphite` exists or if `gt log` succeeds. If unsure, run `gt log` — it either shows the stack or errors clearly.

## Core Mental Model

Graphite tracks a **stack**: an ordered chain of branches, each branching off the one below it. Trunk (usually `main`) is the base. When a branch lower in the stack changes, Graphite can automatically rebase everything above it (`restack`).

Key terms:
- **Trunk**: the base branch (main/master)
- **Stack**: the ordered chain of branches above trunk
- **Upstack**: branches above the current one
- **Downstack**: branches below the current one (toward trunk)

## Essential Commands

### Starting Work

```bash
gt sync                    # Pull trunk, clean up merged branches, restack
gt create -am "description" # Create a new branch, stage all changes, commit with message
gt create                   # Interactive: prompts for branch name and message
```

### Navigating the Stack

```bash
gt log                     # Show the full stack with PR status
gt up                      # Move to the next branch upstack
gt down                    # Move to the next branch downstack
gt top                     # Jump to the top of the stack
gt bottom                  # Jump to the bottom of the stack
gt checkout <branch>       # Switch to any tracked branch (alias: gt co)
```

### Making Changes

```bash
gt modify                  # Amend staged changes to current branch (alias: gt m)
gt modify --all            # Stage all changes, then amend (alias: gt m -a)
gt modify --commit         # Add a new commit instead of amending
gt modify --message "msg"  # Amend with a new commit message
```

### Submitting PRs

```bash
gt submit                  # Push current branch, create/update its PR
gt submit --stack          # Submit all branches in the stack (alias: gt ss)
gt submit --stack --draft  # Submit stack as draft PRs
gt submit --stack --update-only  # Update already-open PRs only (alias: gt ss -u)
gt submit --no-edit        # Skip the PR body editor
```

### Keeping Up to Date

```bash
# gt sync (see Starting Work) covers pulling trunk + cleanup + restack
gt restack                 # Rebase the current branch and everything upstack onto their parents
```

### Restructuring the Stack

```bash
gt move                    # Move current branch to a different parent
gt fold                    # Merge current branch into its parent
gt pop                     # Delete branch, keeping changes as uncommitted diffs
gt squash                  # Squash all commits on current branch into one
# Interactive commands — hand these to the user, they require stdin:
# gt reorder               # Interactively reorder branches in the stack
# gt split                 # Split current branch into multiple branches
```

### Recovery

```bash
gt undo                    # Reverse the most recent Graphite mutation
gt abort                   # Stop an in-progress rebase and restore prior state
```

### Collaboration

```bash
gt get <branch>            # Fetch a teammate's stack locally
gt track                   # Start tracking an existing Git branch with Graphite
gt freeze                  # Prevent accidental changes to a branch
gt unfreeze                # Re-enable changes to a frozen branch
```

## Common Workflows

### Starting a new feature in a stack

```bash
gt sync                         # Get up to date
gt create -m "add auth layer"   # First branch/PR
# ... make changes ...
gt create -m "add user model"   # Second branch, stacked on first
gt ss                           # Submit both as PRs
```

### Amending after PR feedback

```bash
gt co <branch>                  # Check out the relevant branch
# ... make edits ...
gt m -a                         # Stage all and amend
gt ss -u                        # Update the open PRs (don't create new ones)
```

### After trunk advances (teammates merged something)

```bash
gt sync                         # Pulls trunk, cleans up merged branches, restacks
```

### Editing a mid-stack branch

```bash
gt co <mid-stack-branch>
# ... make edits ...
gt m -a                         # Amend the branch
gt restack                      # Rebase everything upstack onto the updated branch
gt ss -u                        # Push updates to all open PRs
```

### Resolving a restack conflict

When `gt restack` hits a conflict:
1. Resolve the conflict in the affected files
2. `git add <files>`
3. `gt restack --continue` — resumes the restack
4. Or `gt abort` to cancel and return to the pre-restack state

## Diagnosing Common Errors

**"Branch is not tracked by Graphite"**: Run `gt track` to register the branch, or `gt create` to make a new tracked branch from the current one.

**"Restack failed with conflicts"**: Resolve conflicts manually, `git add` the resolved files, then `gt restack --continue`. Use `gt abort` to bail out entirely.

**"Stack is out of date"**: Run `gt sync` to pull trunk and restack, then retry the failing command.

**"PR already exists"**: `gt submit` will update it rather than create a new one. Use `--update-only` to be explicit.

## Full Documentation

If a question arises that this skill doesn't cover, fetch the full Graphite docs for LLMs:
`https://graphite.com/docs/llms-full.txt`

## When NOT to Use Graphite

- Personal/solo repos where PRs aren't part of the workflow — use plain Git
- Single-commit changes that don't benefit from stacking — `gt submit` alone is fine, no need for a full stack
