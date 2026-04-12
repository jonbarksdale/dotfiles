---
name: estimating
description: Use when creating issues, reviewing unestimated backlog items, or asked to estimate effort. Encodes the fibonacci scale and drives session/agent planning decisions.
---

# Issue Estimating

## Overview

Effort estimates use a fibonacci scale calibrated to AI session planning — not sprint velocity. The goal is to predict what fits in a context window, when to spawn subagents, and when to just do the work now.

## The Scale

| Score | Label | What it means | Execution approach |
|-------|-------|---------------|--------------------|
| **0** | Do it now | One file, no design choices, under 15 min. Not worth a ticket. | Act immediately if in main agent context; surface as a signal if in a subagent. |
| **1** | Short session | Clear path, narrow file surface. Fits in one context window with room to spare. | Single agent, no planning required. |
| **2** | Full session | Well-scoped, moderate file count. Fills a context window. | Single agent; worth a brief plan first. |
| **3** | Heavy session | Multiple components, non-trivial decisions, or meaningful unknowns. | Single agent with upfront planning, OR main agent + one subagent for an isolated chunk. |
| **5** | Multi-session | Broad scope, architectural decisions, or external integrations with coordination overhead. | Plan first; parallel subagents on independent tracks viable and often preferred. |
| **8** | Break it down | Too large to hold in one session's mental model. | Decompose into sub-issues first. Do not implement until broken down. |

## When to Invoke This Skill

- When creating a new issue (any tracker — Linear, Jira, Asana, GitHub) — estimate before saving
- When reviewing issues without estimates (e.g., backlog grooming)
- When about to start work — confirm the estimate still fits reality

## Estimation Workflow

1. **Read the full issue** — title + description + acceptance criteria
2. **Identify signals** (see table below)
3. **Assign the score**
4. **Handle score 0** (see below)
5. **Record the estimate** in the issue tracker for scores 1+

## Handling Score 0

Whether to act immediately depends on execution context:

- **Main agent context**: skip filing the ticket, execute the fix now if sufficient context remains
- **Subagent context** (e.g., grooming pass, batch estimation): return the score and surface it as "do this now" to the caller — don't implement inside the subagent

## Scoring Signals

| Signal | Pushes toward |
|--------|---------------|
| Single file or function touched | 0–1 |
| New module/component with clear spec | 2 |
| Multiple modules + shared state coordination | 3 |
| A decision must be made before implementation can start | +1 |
| External service account or credentials required | +1 |
| Cross-environment verification needed (devices, browsers, OS) | +1 |
| Can't be fully tested headlessly or automatically | +1 |
| Known hidden complexity in the problem domain | +1 |
| New pattern not yet established in this codebase | +1 |
| Unclear acceptance criteria | +1 (uncertainty tax) |
| Scope spans multiple subsystems | 5–8 |

## Execution Decision Tree

```
Score 0?   → Do it now (main agent) or surface to caller (subagent). No ticket.
Score 1–2? → Single session, single agent.
Score 3?   → Write a plan first. Consider one subagent for isolation.
Score 5?   → Decompose tasks, use parallel subagents on independent tracks.
Score 8?   → Stop. File sub-issues. Re-estimate the pieces.
```

## Observed Mistakes

These are from real experience, not speculation:

- **Underestimating problems with known hidden complexity** — e.g., gesture/scroll conflict in mobile drawers looks like a 1 but is a 3. Ask: does this problem domain have a known hard edge case?
- **Ignoring external setup steps** — if a human needs to create accounts, add secrets, or approve access before work can complete, add 1 point. Coordination overhead is real effort.
- **Estimating implementation only** — include tests, integration verification, and review in the estimate. They are not free.
- **Not acting on 0s** — if it's genuinely zero effort, fix it in the conversation rather than creating ticket churn.
