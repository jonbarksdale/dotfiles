# pr-stacking skill — design

Date: 2026-08-10

## Problem

The `graphite` skill is a single-tool reference for the Graphite CLI (`gt`). Two
changes make it a poor fit going forward:

1. Jon now also uses `gh stack` (github/gh-stack), and will keep using both — `gt`
   is more mature; `gh stack` is more ubiquitous. Both are useful.
2. The two tools share one mental model (stacked PRs: init → add → submit → sync →
   restack → restructure) and differ only in command names. A single-tool skill
   can't cover both, and duplicating the workflow prose across two tool-specific
   skills would rot.

A related question — whether to fold stacking into the `commit` skill — is answered
no: `commit` answers "what goes into this commit" (atomic grouping, conventional
format); stacking answers "how do these branches/PRs relate." Merging them would
overload a cleanly-bounded skill and blur its trigger.

## Goals

- One concept-level stacking skill covering both `gt` and `gh stack`.
- Deterministic tool selection with no ambiguity for the agent.
- Keep `commit` bounded, but make it stacking-aware so it doesn't do the wrong
  thing (raw `git commit`) in a stacking repo.

## Non-goals

- No changes to `commit`'s atomic-grouping or conventional-message logic.
- No support for stacking tools beyond `gt` and `gh stack`.

## Design

### New skill: `pr-stacking`

Replaces the `graphite` skill. Concept-level SKILL.md with one reference file per
tool (progressive disclosure — the mental model and workflows live once, at the top;
exact commands live in the tool references).

```
dot_claude/skills/pr-stacking/          (chezmoi source)
  SKILL.md
  references/
    graphite.md
    gh-stack.md
```

Rendered target: `~/.claude/skills/pr-stacking/`.

**SKILL.md** (tool-agnostic, ~one screen):

- **Frontmatter** — `name: pr-stacking`; description triggers on "stack",
  "stacked PRs", "stacked diffs", `gt`, `gh stack`, and proactively on stacking
  workflow in collaborative repos.
- **Core mental model** — trunk / stack / upstack / downstack. Tool-independent.
- **Tool selection rule** (deterministic, side-effect-free):
  1. If the user names a tool, honor it.
  2. Else if graphite is detected, use `gt`. **Detect by file marker only** —
     `.git/.graphite_repo_config` (present from `gt` init onward; accept
     `.git/refs/graphite` too, which appears once branches are tracked). Do NOT
     probe with `gt log`: in a non-graphite repo `gt log` silently *initializes*
     Graphite (auto-creates `.git/.graphite_repo_config` etc.), so it mutates the
     state it's meant to measure and would misreport a plain repo as graphite.
     Confirm the marker filename against the installed `gt` version.
  3. Else default to `gh stack`.
- **Concept-level workflows** described by intent, each pointing to the active
  tool's reference for exact commands: start a feature stack, amend after review,
  sync after trunk moves, edit a mid-stack branch, resolve a restack/rebase
  conflict.
- **When NOT to stack** — solo repos without PRs; single-commit changes.
- **Composition note** — for commit messages during stacking, defer to the
  `commit` skill's conventional format rather than restating it.

**references/graphite.md** — the command tables and error-diagnosis content from
today's `graphite/SKILL.md`, trimmed to a command reference (mental-model and
workflow prose moves up to the new SKILL.md). Includes the full-docs pointer
(`https://graphite.com/docs/llms-full.txt`).

**references/gh-stack.md** — parallel command reference for `gh stack`
(init/add/submit/sync/rebase/modify/view/checkout/link/merge/unstack), its own
detection notes, and error cases. Command details derived from `gh stack --help`
and per-subcommand `--help` output while writing — real flags, not guessed.
Flag interactive subcommands (`gh stack modify` restructures a stack via TUI;
`gt reorder`/`gt split` on the graphite side) as hand-to-user, not agent-runnable
— parallel to how the graphite reference already marks its interactive commands.

### Delete: `graphite` skill

Remove `dot_claude/skills/graphite/` from the chezmoi source so the misleading
single-tool name stops triggering. No redirect stub.

### Modify: `commit` skill

Prepend a minimal one-way guard as a new first step of the `commit` WORKFLOW
section (before `git status`), no rewrite:

> Before committing, check for a stacking repo — graphite init present
> (`.git/.graphite_repo_config`, or `.git/refs/graphite`), or an active gh-stack
> (`gh stack view` succeeds on a tracked stack). If found, route the commit
> through the stacking tool (invoke `pr-stacking`) rather than raw `git commit` —
> untracked commits desync the stack. Atomic grouping and conventional-message
> logic still apply; they just route through `gt create`/`gt modify` or
> `gh stack add`.

Note the detection asymmetry: graphite is a file check, but gh-stack detection
spawns `gh stack view` on every commit in non-graphite repos. Acceptable, but
call it out in the guard so it's a conscious cost, not a surprise.

Properties:

- One-way dependency (commit → pr-stacking); no cycle. pr-stacking only defers to
  commit's message format, which already exists.
- No-op in normal (non-stacking) repos — the common case is unchanged.
- Prevents `commit` from silently desyncing a stack in exactly the repos where it
  matters most.

## Implementation notes

- **Chezmoi-managed.** These skills live in the chezmoi source at
  `~/.local/share/chezmoi/dot_claude/skills/`. All edits happen in the source tree,
  then `chezmoi apply` renders to `~/.claude/skills/`. Do not edit `~/.claude`
  directly. Follow the `chezmoi` skill.
- Three-part change: add `pr-stacking/`, delete `graphite/`, edit `commit/SKILL.md`.

## Verification

- Both reference files' commands checked against `gt --help` and
  `gh stack --help` (and relevant subcommand help) — no invented flags.
- `chezmoi apply` renders `pr-stacking/` to `~/.claude/skills/` and removes
  `graphite/`; confirm the target tree matches.
- The tool-selection rule is stated explicitly and is deterministic (user override
  → graphite detection → gh-stack default).
- Detection is side-effect-free: confirm graphite is detected by reading
  `.git/.graphite_repo_config`, never by running `gt log` (which would initialize
  Graphite in a plain repo). Verify the marker filename on the installed `gt`
  version before relying on it.
- `commit/SKILL.md` guard is a no-op in a non-stacking repo and routes to
  `pr-stacking` when a stack is detected.

## Success criteria

- Asking for stacking help in a graphite repo yields `gt` commands; in a
  non-graphite repo yields `gh stack` commands; a named tool always wins.
- `commit` in a stacking repo routes through the stacking tool instead of raw
  `git commit`.
- No remaining references to a `graphite`-named skill.
