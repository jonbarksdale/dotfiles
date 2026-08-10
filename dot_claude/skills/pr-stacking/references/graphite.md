<!-- ABOUTME: Graphite CLI (gt) command reference for the pr-stacking skill. -->
<!-- ABOUTME: Command mappings, error diagnosis, and the full-docs pointer. -->

# Graphite (`gt`) Command Reference

## Detecting Graphite
Graphite is initialized when `.git/.graphite_repo_config` exists (from init onward) or `.git/refs/graphite` exists (once branches are tracked). Detect by file marker only — never run `gt log` to probe (it initializes Graphite as a side effect).

## Starting Work
| Command | Purpose |
|---|---|
| `gt sync` | Pull trunk, clean up merged branches, restack |
| `gt create -am "msg"` | New branch, stage all, commit |
| `gt create` | Interactive: prompts for name + message (hand to user) |

## Navigating
`gt log` (show stack), `gt up`, `gt down`, `gt top`, `gt bottom`, `gt checkout <branch>` (alias `gt co`).

## Making Changes
`gt modify` (amend staged; alias `gt m`), `gt modify --all` (`gt m -a`), `gt modify --commit` (new commit), `gt modify --message "msg"`.

## Submitting
`gt submit`, `gt submit --stack` (alias `gt ss`), `gt submit --stack --draft`, `gt submit --stack --update-only` (`gt ss -u`), `gt submit --no-edit`.

## Staying Up to Date
`gt sync` (see above), `gt restack` (rebase current + upstack onto parents).

## Restructuring
`gt move`, `gt fold`, `gt pop`, `gt squash`.
**Interactive — hand to user (require stdin):** `gt reorder`, `gt split`.

## Recovery
`gt undo` (reverse last Graphite mutation), `gt abort` (stop in-progress rebase, restore prior state).

## Collaboration
`gt get <branch>`, `gt track`, `gt freeze`, `gt unfreeze`.

## Resolving a Restack Conflict
1. Resolve conflicts in the affected files.
2. `git add <files>`
3. `gt restack --continue` — resumes; or `gt abort` to cancel.

## Common Errors
- **"Branch is not tracked by Graphite"** — `gt track`, or `gt create` from current.
- **"Restack failed with conflicts"** — resolve, `git add`, `gt restack --continue`; `gt abort` to bail.
- **"Stack is out of date"** — `gt sync`, then retry.
- **"PR already exists"** — `gt submit` updates it; use `--update-only` to be explicit.

## Full Documentation
If something isn't covered here, fetch the Graphite LLM docs: `https://graphite.com/docs/llms-full.txt`
