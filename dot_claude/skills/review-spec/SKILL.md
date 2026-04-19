---
name: review-spec
description: Review design specs for correctness, completeness, consistency, quality, implementability, and risks. Verifies claims against source code. Invoke with /review-spec <path-to-spec>.
---

# Design Spec Review

Review implementation design specs by verifying claims against source code and evaluating across six dimensions.

## Quick Reference

**Process**:
1. Read the spec and identify every verifiable claim
2. Cross-reference claims against source code (line numbers, signatures, patterns)
3. Check alignment with project standards (CLAUDE.md, existing conventions)
4. Report findings by dimension, skip clean dimensions

**Dimensions**:
- **Correctness**: Are verifiable claims true? (line numbers, signatures, precedent citations)
- **Completeness**: Any gaps, missing scenarios, or unaddressed edge cases?
- **Consistency**: Does the design align with project standards and existing patterns?
- **Quality**: Latent defects, error-prone interfaces, fragile assumptions?
- **Implementability**: Can someone implement without ambiguity or unstated decisions?
- **Risks**: What could go wrong? (security, performance, rollback when relevant)

**Output**: Narrative findings by dimension, ending with a summary of substantive issues. Skip dimensions with nothing to report.

See [reference.md](./reference.md) for detailed standards.
