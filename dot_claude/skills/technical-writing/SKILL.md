---
name: technical-writing
description: Technical documentation standards for both writing and reviewing. Use when creating new documentation, writing ADRs, drafting technical specs, reviewing existing docs for quality, or critiquing technical writing. Triggers on any documentation task, whether creating, editing, or reviewing.
---

# Technical Writing Standards

Standards for creating and reviewing technical documentation.

## Writing Process

1. Identify audience and purpose
2. Create outline with key sections
3. Fill content (use FAQ section for homeless details)
4. Move inappropriate details to appendix
5. Write executive summary last
6. Review using the five-question framework

## Review Checklist

When reviewing documentation, check:

**Structure**: Purpose statement clear? Executive summary written last? Follows document structure standards?

**Clarity**: Acronyms defined at first use? No weasel words? Conclusions not buried?

**Reader Value**: Optimized for reader's time? No mental math required? No unnecessary cross-referencing?

## Document Quality

- Lint markdown with `markdownlint-cli2`
- 120 character line limit
- Consistent heading hierarchy
- Code blocks with language specifier

## ADR Structure (Enhanced MADR)

- **Status**: Proposed/Accepted/Rejected/Deprecated/Superseded
- **Date**: Decision date
- **Context**: Background and problem statement
- **Decision**: What was decided
- **Rationale**: Why this decision was made
- **Consequences**: Positive, Negative, Neutral outcomes
- **Alternatives**: Other options with pros/cons
- **Implementation Notes**: Practical guidance

## AI Writing Anti-Patterns

Avoid these common AI writing tropes (see reference.md for full list):

**Word choice**: Don't use "delve," "leverage," "robust," "harness," "tapestry," "landscape," "paradigm." Don't replace "is" with "serves as" or "stands as."

**Sentence structure**: Avoid "It's not X — it's Y" reframes, dramatic countdowns ("Not X. Not Y. Just Z."), rhetorical self-questions ("The result? Devastating."), and filler transitions ("It's worth noting," "Importantly").

**Tone**: No false suspense ("Here's the kicker"), no patronizing analogies ("Think of it as..."), no stakes inflation. Don't "unpack" or "break down" for expert audiences.

**Formatting**: Don't overuse em dashes (—). One or two per document is fine; more than that is a tell. Use commas, parentheses, or separate sentences instead.

**Composition**: Don't repeat yourself at every level (fractal summaries). Don't announce conclusions ("In conclusion"). State things once, clearly.

See [reference.md](./reference.md) for complete standards, weasel word list, and full AI anti-patterns catalog.
