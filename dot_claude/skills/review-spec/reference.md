# Design Spec Review — Detailed Standards

## Process

### 1. Read and Parse

Read the spec end-to-end. Identify:
- **Verifiable claims**: line numbers, function signatures, complexity scores, file paths, pattern references
- **Precedent citations**: "matches the existing X pattern," "follows the Y convention"
- **Project rule references**: CLAUDE.md rules, architectural constraints, testing policies
- **Assumptions**: stated assumptions that can be checked against reality

### 2. Verify Against Source

For every verifiable claim, check the source:
- **Line numbers**: Read the cited lines. Does the code there match the description?
- **Function signatures**: Do the proposed parameters cover what the extracted code actually needs?
- **Precedent claims**: Read the cited precedent. Does the analogy hold, or does it overstate the similarity?
- **Complexity estimates**: Are the residual complexity estimates plausible given what remains in the caller?
- **File paths**: Do referenced files exist at the stated locations?

### 3. Check Project Standards

Read CLAUDE.md and any relevant project conventions. Look for:
- Tensions between the spec's approach and stated project rules
- Implicit rule violations the spec doesn't acknowledge
- Deviations from established patterns without justification

Even when the spec's reasoning for deviating is sound, surface the tension — the spec should acknowledge it explicitly rather than hoping reviewers don't notice.

### 4. Evaluate and Report

Walk through each dimension with findings. Skip dimensions where there is nothing to report — do not pad with "no issues found." End with a summary distinguishing substantive issues from suggestions.

## Review Dimensions

### Correctness

Core question: **Are the claims in this spec verifiable and true?**

What to check:
- Line number references match the actual source code
- Function signatures include all parameters the extracted code needs
- Precedent citations accurately describe the cited code (watch for overstated analogies or inverted semantics)
- Complexity scores match what a tool would report
- Return type descriptions match the actual data flow
- Stated behavior matches what the code actually does

Common failure mode: A spec says "this follows the same pattern as X" but the pattern's semantics differ in ways that matter (e.g., None-means-failure vs. None-means-continue).

### Completeness

Core question: **Is anything missing that an implementer would need?**

What to check:
- Are all code paths in the referenced source accounted for in the extraction plan?
- Are error handling paths described, not just the happy path?
- Does the spec cover what happens when estimates are wrong (e.g., complexity exceeds budget)?
- Are boundary conditions explicit (e.g., which lines belong to the helper vs. the caller)?
- If the spec cites multiple error types, does the description mention all of them?
- Are escape valves documented for the tightest constraints?

Common failure mode: A spec describes a helper that "handles timeout retry" but the actual code also handles HTTPError — the description is accurate but incomplete.

### Consistency

Core question: **Does this design align with project standards and existing patterns?**

What to check:
- CLAUDE.md architectural rules (layer boundaries, import restrictions, testing policies)
- Existing naming conventions and return type patterns in the codebase
- Whether the spec acknowledges tensions with project rules rather than silently violating them
- Whether similar helpers elsewhere in the codebase follow the same conventions the spec proposes
- Whether the testing approach satisfies stated testing policies (even for refactors)

Common failure mode: A project rule says "no private business logic helpers in cli.py" and the spec adds helpers to cli.py. The helpers may genuinely be presentation code, but the spec should acknowledge and justify the apparent tension.

### Quality

Core question: **Are there latent defects, error-prone interfaces, or fragile assumptions?**

What to check:
- Positional return types (tuples) where field ordering differs between sibling functions
- Union return types where the caller could confuse the variants
- Assumptions about mutation ordering, state, or side effects
- Interfaces where two reasonable implementations would produce different behavior
- Fragile estimates (e.g., "~11 complexity, limit is 12" with no escape valve)
- Whether stated assumptions are actually true

Common failure mode: Two sibling functions return `tuple[str, int, int, int, int]` but the int fields are in different order — a positional destructuring mistake silently swaps values.

### Implementability

Core question: **Can someone implement this spec without coming back to ask questions?**

What to check:
- Ambiguous boundaries (which code moves into the helper vs. stays in the caller?)
- Unstated decisions the implementer would need to make
- Whether the execution order makes sense (dependencies between steps)
- Whether the spec is precise enough to produce a single correct implementation or leaves forks that different implementers would resolve differently
- Whether parameter names and types are specific enough to implement from

Common failure mode: A spec says "extract lines 395–424" but line 395 is a guard condition — it's unclear whether the guard moves into the helper or stays in the caller.

### Risks

Core question: **What could go wrong during or after implementation?**

What to check:
- **Security**: Does the change introduce new inputs, I/O surfaces, or trust boundaries?
- **Performance**: Could the change introduce latency, memory, or concurrency issues?
- **Rollback**: If the change doesn't work, how hard is it to revert?
- **Estimation risk**: Are the tightest constraints (complexity budgets, size limits) close enough to fail?
- **Behavioral risk**: Could the refactor subtly change behavior even though it's intended as a pure extraction?
- **Ordering risk**: If the spec relies on sequential processing, could parallelism or reordering break it?

For pure refactors, security and performance risks are usually trivially clear — state this briefly and move on. Focus risk analysis on what's actually uncertain.

## Output Format

### Structure

```
## Spec Review: <Title>

### <Dimension> — <one-line verdict>

<Narrative findings with specific references to spec sections and source code.
Each finding should cite what the spec says, what reality is, and why it matters.>

### <Next dimension>
...

### Summary

<List of substantive issues to address before execution, distinguishing
between things that must change and things that would improve the spec.>
```

### Guidelines

- **Skip clean dimensions.** If correctness checks all pass, don't write a section saying so.
- **Cite specifically.** "Line 116 claims X, but `_resolve_page_id` at cli.py:132 returns `str | None`, not `int | None`" — not "the precedent claim is inaccurate."
- **Distinguish severity.** End the summary with a clear split: substantive issues (must address) vs. suggestions (would improve).
- **No severity inflation.** A spec with zero issues is a good spec. Say so.
