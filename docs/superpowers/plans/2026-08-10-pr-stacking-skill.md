# pr-stacking Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the single-tool `graphite` skill with a tool-neutral `pr-stacking` skill covering both `gt` and `gh stack`, and make the `commit` skill stacking-aware.

**Architecture:** One concept-level `SKILL.md` (mental model, deterministic tool selection, intent-level workflows) with a command reference per tool under `references/`. Delete the old `graphite` skill. Add a one-way guard to `commit` that routes commits through the stacking tool when a stack is detected. All skill files are chezmoi source; edits render to `~/.claude/skills/` via `chezmoi apply`.

**Tech Stack:** Markdown skills, chezmoi, `gt` (Graphite CLI), `gh stack` (github/gh-stack extension).

## Global Constraints

- **Chezmoi source of truth.** Edit only under `dot_claude/skills/…` in the repo (`~/.local/share/chezmoi` is a symlinked path into this same repo — toplevel `/Users/jobarksdale/developer/paypal/code/dotfiles`). Never edit `~/.claude/skills/` directly; render with `chezmoi apply`.
- **Side-effect-free detection.** Detect graphite by the file marker `.git/.graphite_repo_config` (accept `.git/refs/graphite` too). NEVER probe with `gt log` — in a non-graphite repo it silently initializes Graphite.
- **No invented flags.** Every command/flag in the references must exist in `gt --help` / `gh stack --help` output. Interactive (TUI/stdin) commands are marked hand-to-user, not agent-runnable.
- **ABOUTME headers.** Per the user's global CLAUDE.md, each file starts with a 2-line `ABOUTME: ` comment. For Markdown skills, place it as an HTML comment immediately after the frontmatter.
- **Commit format:** conventional commits, no `--no-verify`.
- **Source spec:** `docs/superpowers/specs/2026-08-10-pr-stacking-skill-design.md`.

---

## File Structure

- Create `dot_claude/skills/pr-stacking/SKILL.md` — concept-level skill.
- Create `dot_claude/skills/pr-stacking/references/graphite.md` — `gt` command reference (trimmed from old skill).
- Create `dot_claude/skills/pr-stacking/references/gh-stack.md` — `gh stack` command reference (new).
- Delete `dot_claude/skills/graphite/SKILL.md` (and the now-empty `graphite/` dir).
- Modify `dot_claude/skills/commit/SKILL.md` — prepend stacking guard to WORKFLOW.

---

## Task 1: pr-stacking SKILL.md (concept-level)

**Files:**
- Create: `dot_claude/skills/pr-stacking/SKILL.md`

**Interfaces:**
- Produces: the `pr-stacking` skill invocable by name; references at `references/graphite.md` and `references/gh-stack.md` (created in Tasks 2–3).

- [ ] **Step 1: Write the file**

Write `dot_claude/skills/pr-stacking/SKILL.md` with exactly this content:

````markdown
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
````

- [ ] **Step 2: Verify structure**

Run: `head -5 dot_claude/skills/pr-stacking/SKILL.md`
Expected: frontmatter with `name: pr-stacking`, followed by the two `ABOUTME:` comment lines.

- [ ] **Step 3: Verify no side-effecting detection leaked in**

Run: `grep -n "gt log" dot_claude/skills/pr-stacking/SKILL.md`
Expected: the only match is the ⚠️ line warning *against* using `gt log` for detection. No line instructs running `gt log` to detect.

- [ ] **Step 4: Commit**

```bash
git add dot_claude/skills/pr-stacking/SKILL.md
git commit -m "feat(skills): add tool-neutral pr-stacking skill"
```

---

## Task 2: graphite command reference

**Files:**
- Create: `dot_claude/skills/pr-stacking/references/graphite.md`
- Source material: `dot_claude/skills/graphite/SKILL.md` (existing, still present — trim its command tables and error-diagnosis content; the mental-model/workflow prose now lives in Task 1's SKILL.md).

**Interfaces:**
- Consumes: linked from `SKILL.md` as `references/graphite.md`.
- Produces: `gt` command reference.

- [ ] **Step 1: Write the file**

Read `dot_claude/skills/graphite/SKILL.md` for the source command content, then write `dot_claude/skills/pr-stacking/references/graphite.md`. Keep the command tables verbatim (they were already correct), drop the "Core Mental Model" and "Common Workflows" prose (now in SKILL.md), and mark interactive commands as hand-to-user. Structure:

````markdown
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
````

- [ ] **Step 2: Verify no invented flags**

Run: `gt --help` and spot-check `gt submit --help`, `gt modify --help`.
Expected: every command/flag in the reference appears in `gt` help output. Fix any mismatch.

- [ ] **Step 3: Commit**

```bash
git add dot_claude/skills/pr-stacking/references/graphite.md
git commit -m "feat(skills): add graphite command reference to pr-stacking"
```

---

## Task 3: gh-stack command reference

**Files:**
- Create: `dot_claude/skills/pr-stacking/references/gh-stack.md`

**Interfaces:**
- Consumes: linked from `SKILL.md` as `references/gh-stack.md`.
- Produces: `gh stack` command reference.

- [ ] **Step 1: Confirm command surface**

Run: `gh stack --help`, plus `gh stack add --help`, `gh stack submit --help`, `gh stack sync --help`, `gh stack rebase --help`, `gh stack view --help`.
Expected: confirms the subcommands/flags used below still exist. Fix the reference if the installed version differs.

- [ ] **Step 2: Write the file**

Write `dot_claude/skills/pr-stacking/references/gh-stack.md`:

````markdown
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
````

- [ ] **Step 3: Verify no invented flags**

Run: re-check any flag you're unsure of against `gh stack <sub> --help`.
Expected: every flag (`--auto`, `--open`, `--prune`, `--downstack`, `--upstack`, `--no-trunk`, `--yes`, `--squash`, `--local`, `-A`, `-u`, `-m`, `--base`) appears in the corresponding help. Fix mismatches.

- [ ] **Step 4: Commit**

```bash
git add dot_claude/skills/pr-stacking/references/gh-stack.md
git commit -m "feat(skills): add gh-stack command reference to pr-stacking"
```

---

## Task 4: Delete the old graphite skill

**Files:**
- Delete: `dot_claude/skills/graphite/SKILL.md` (and the `graphite/` dir).

**Interfaces:**
- Consumes: nothing — Task 2 already copied the needed content.
- Produces: removal of the misleading single-tool skill name.

- [ ] **Step 1: Confirm content was carried over**

Run: `test -f dot_claude/skills/pr-stacking/references/graphite.md && echo OK`
Expected: `OK` (Task 2 completed — safe to delete the source).

- [ ] **Step 2: Remove the skill**

```bash
git rm dot_claude/skills/graphite/SKILL.md
```

Run: `ls dot_claude/skills/graphite 2>/dev/null || echo "graphite dir gone"`
Expected: `graphite dir gone` (git removes the now-empty dir).

- [ ] **Step 3: Commit**

```bash
git commit -m "refactor(skills): remove graphite skill superseded by pr-stacking"
```

---

## Task 5: Make the commit skill stacking-aware

**Files:**
- Modify: `dot_claude/skills/commit/SKILL.md` (the `# WORKFLOW` section, currently starting at "1. Run `git status`…").

**Interfaces:**
- Consumes: `pr-stacking` skill (Task 1) — invoked by the guard.
- Produces: a one-way guard; commit's atomic/conventional logic is otherwise unchanged.

- [ ] **Step 1: Read the current workflow**

Run: `grep -n "# WORKFLOW" dot_claude/skills/commit/SKILL.md`
Expected: locates the WORKFLOW heading so the guard is prepended as a new step 0 before the existing step 1.

- [ ] **Step 2: Insert the guard**

Edit `dot_claude/skills/commit/SKILL.md`: immediately under the `# WORKFLOW` heading, before the existing "1. Run `git status`…", insert:

```markdown
0. **Stacking-repo check (routing guard).** Before any raw `git commit`, check whether this is a stacked-PR repo:
   - Graphite: `.git/.graphite_repo_config` exists (or `.git/refs/graphite`). Detect by file only — never run `gt log`.
   - gh-stack: `gh stack view` exits zero on a tracked stack (check the exit code directly, unpiped).
   If either is true, route the commit through the stacking tool via the `pr-stacking` skill (`gt create`/`gt modify` or `gh stack add`) instead of raw `git commit` — an untracked `git commit` desyncs the stack. The atomic-grouping and conventional-message logic below still applies; it just runs through the stacking tool. In a normal (non-stacking) repo this check is a no-op — continue to step 1.
   Note: the gh-stack check spawns `gh stack view` on every commit in non-graphite repos; that subprocess cost is intentional.
```

Renumber is not required — the existing steps stay 1–4; this is step 0.

- [ ] **Step 3: Verify the edit**

Run: `sed -n '/# WORKFLOW/,/# OUTPUT FORMAT/p' dot_claude/skills/commit/SKILL.md`
Expected: step 0 guard appears before step 1; `pr-stacking`, `.git/.graphite_repo_config`, and "never run `gt log`" all present; no `gt log`-as-probe instruction.

- [ ] **Step 4: Commit**

```bash
git add dot_claude/skills/commit/SKILL.md
git commit -m "feat(skills): route commits through pr-stacking in stacked repos"
```

---

## Task 6: Render and verify end-to-end

**Files:** none created — this renders source to target and validates.

- [ ] **Step 1: Render with chezmoi**

Run: `chezmoi apply --dry-run --verbose ~/.claude/skills` then, if it looks right, `chezmoi apply ~/.claude/skills`
Expected: dry-run shows `pr-stacking/` (3 files) added and `graphite/` removed. If `graphite/` is NOT removed by apply, run `chezmoi apply` again or remove the target explicitly and confirm chezmoi no longer manages it (`chezmoi managed ~/.claude/skills | grep graphite` returns nothing).

- [ ] **Step 2: Verify the rendered tree**

Run:
```bash
ls ~/.claude/skills/pr-stacking ~/.claude/skills/pr-stacking/references
test ! -e ~/.claude/skills/graphite && echo "graphite removed"
```
Expected: `SKILL.md` + `references/{graphite,gh-stack}.md` present; `graphite removed`.

- [ ] **Step 3: Verify no dangling references to the old skill**

Run: `grep -rn "skills/graphite\|name: graphite" dot_claude/ ~/.claude/CLAUDE.md 2>/dev/null`
Expected: no matches (the deleted skill isn't referenced anywhere). If `~/.claude/CLAUDE.md` or its chezmoi source lists a `graphite` skill, that is out of scope for this plan — note it as a follow-up issue rather than editing here.

- [ ] **Step 4: Verify detection marker filename on installed gt**

Run: `gt --version`
Expected: record the version. If it differs from the version the markers were verified against, initialize a throwaway test repo, run a graphite init, and confirm `.git/.graphite_repo_config` is the marker created. Do NOT run `gt log` in any repo you want to keep non-graphite.

- [ ] **Step 5: Final status check**

Run: `git status --short && git log --oneline -6`
Expected: clean working tree; commits from Tasks 1–5 present.

---

## Self-Review (completed by plan author)

**Spec coverage:**
- New `pr-stacking` skill (SKILL.md + 2 references) → Tasks 1–3. ✔
- Deterministic, side-effect-free detection → Task 1 (rule), Tasks 2–3 (per-tool notes), Task 6 Step 4 (version check). ✔
- Delete `graphite` → Task 4. ✔
- `commit` guard with corrected marker + per-commit cost note + named insertion point → Task 5. ✔
- Interactive commands flagged hand-to-user → Tasks 2–3. ✔
- Chezmoi source-of-truth flow → Global Constraints + Task 6. ✔
- Verification (no invented flags, render matches, no dangling refs) → Tasks 2/3 Step "verify", Task 6. ✔

**Placeholder scan:** No TBD/TODO; all file contents are inline and complete. ✔

**Type/name consistency:** Skill name `pr-stacking` and reference paths `references/graphite.md` / `references/gh-stack.md` are identical across Tasks 1, 2, 3, and 6. Detection marker `.git/.graphite_repo_config` is identical in Tasks 1, 2, and 5. ✔
