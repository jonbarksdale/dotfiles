# Documentation Review Detailed Standards

## Five-Question Review Framework

When reviewing any documentation, ask:

1. **Is the problem clear?**
   - Can a reader understand what problem this doc addresses?
   - Is the context sufficient for someone unfamiliar?

2. **Is the plan clear?**
   - What action or decision does this doc support?
   - Are the steps or recommendations explicit?

3. **Does the plan make sense?**
   - Does the proposed solution actually solve the stated problem?
   - Are trade-offs acknowledged and reasonable?

4. **Are details faithful to the plan?**
   - Do specifics match the stated approach?
   - No contradictions between sections?

5. **Are there low/no-risk ways to improve?**
   - Minor clarifications, formatting, typo fixes
   - Additional examples that would help

## Structure Standards

### Technical Documents
1. **Executive Summary** (write last, after content is complete)
2. **Purpose Statement** - Clear document goal
3. **Problem Statement** - From customer's perspective
4. **Requirements** - Core constraints that impact solution
5. **Approach** - Solution strategy and trade-offs
6. **Solution Details** - Detailed design information
7. **Appendix** - FAQ, glossary, alternatives, references

### Architecture Decision Records (ADRs)
Follow enhanced MADR format:
- **Status**: Proposed | Accepted | Deprecated | Superseded
- **Date**: When decision was made
- **Context**: Forces at play, problem statement
- **Decision**: What was decided and why
- **Rationale**: Detailed reasoning
- **Consequences**: Positive and negative outcomes
- **Alternatives**: Options considered and why rejected
- **Implementation Notes**: Key details for implementers

## Clarity Standards

### Acronyms and Terminology
- Define every acronym at first usage
- Don't assume domain knowledge without stating assumptions
- Include a glossary for documents with many terms

### Weasel Words to Flag
Vague qualifiers that should be replaced with specifics:
- "Significantly" → quantify the improvement
- "Generally" → specify the conditions
- "Many" → give actual numbers or percentages
- "Should" → clarify if required or recommended
- "Simple" → simple for whom? Under what conditions?
- "Fast" → how fast? Measured how?

### Structure for Clarity
- Don't bury the lede - lead with conclusions
- Use headings liberally for scannability
- One idea per paragraph
- Use lists for 3+ related items

## Reader Value Standards

### Optimize for Reader's Time
- Put the most important information first
- Use formatting to enable skimming
- Include a TL;DR for long documents

### Don't Make Readers Work
- Include calculations (don't expect readers to do math)
- Duplicate small content if it saves jumping between sections
- Provide concrete examples, not just abstract descriptions

### Completeness Checks
- Can someone new follow this without asking questions?
- Are edge cases and exceptions documented?
- Are next steps or action items clear?

## Formatting Standards

### Markdown Linting
- Line length: 80 characters max
- One blank line between sections
- Consistent heading hierarchy (don't skip levels)
- Code blocks with language specifier

### Diagram Standards
- Include a legend unless following strict UML
- Keep colors, shapes, sizes consistent
- Prefer sequence diagrams for call ordering
- Ensure diagrams are accessible (alt text, text descriptions)

## Common Issues to Flag

### Anti-Patterns
- Wall of text without headings or breaks
- Assumptions about reader knowledge without stating them
- Passive voice hiding who does what
- Missing dates on time-sensitive content
- Broken links or references

### Missing Elements
- No version or date information
- No owner or point of contact
- No status indicator (draft, final, deprecated)
- No change history for living documents
