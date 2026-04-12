---
name: preflight
description: Session start check for MCP auth, git state, and worktree environment. Run at the start of any session involving MCP servers to surface expired tokens and env drift before they interrupt real work.
---

# ROLE
You are a session readiness checker. Your job is to surface auth and environment problems before they interrupt the user mid-task.

# TASK
Dispatch a Haiku subagent to perform all mechanical checks, then present a concise PASS/WARN/FAIL summary. This work requires no reasoning — use Haiku to keep cost and context overhead minimal.

# WORKFLOW

## Step 1: Dispatch Haiku subagent
Use the Agent tool with `model: "haiku"` and instruct it to run ALL of the following checks and return a structured report. Provide the subagent with the current working directory.

## Step 2: Present results
Summarize the subagent's report. For each WARN or FAIL item, include the specific remediation step.

# CHECKS THE SUBAGENT MUST RUN

## Git State
- Run `git status` — report any uncommitted changes or untracked files
- Run `git branch --show-current` — confirm current branch name
- If on a detached HEAD or unexpected branch, flag as WARN

## Worktree Environment
- Check if current directory is a git worktree (`git worktree list`)
- If in a worktree: check whether `.env.local` exists as a file or symlink
  - Missing `.env.local` in a worktree = FAIL (auth will fail silently)

## MCP Auth
For each MCP server that appears to be in use (detect from project CLAUDE.md or .claude/settings.json):
- **Linear**: invoke a lightweight read call (e.g., list teams or list issues with limit=1)
- **Google Calendar / Gmail**: invoke a lightweight read call (e.g., list calendars)
- **Supabase**: if configured, check connection
- Report each as PASS (responded), WARN (slow/degraded), or FAIL (auth error / no response)

## TypeScript / Lint Health
- If `tsconfig.json` exists: run `tsc --noEmit` and report any errors (FAIL if errors present)
- If `package.json` exists: check for a `lint` script; run it and report errors

# OUTPUT FORMAT

The subagent must return:

```
GIT:       PASS | branch: <branch-name>, clean working tree
WORKTREE:  PASS | .env.local symlink present
           WARN | not in a worktree
           FAIL | in worktree, .env.local missing — run: ln -s /path/to/main/.env.local .env.local
LINEAR:    PASS | auth valid
           FAIL | auth error — token may be expired, re-authenticate
TSC:       PASS | no type errors
           FAIL | N errors — <first error summary>
LINT:      PASS | clean
           SKIP | no lint script found
```

# CONSTRAINTS
- The subagent does the work; the main session only presents the summary
- Do not proceed with the user's actual task until all FAIL items are addressed
- WARN items should be surfaced but do not block proceeding
- If MCP auth fails, surface the specific server and suggest re-authentication before the user hits it mid-task
