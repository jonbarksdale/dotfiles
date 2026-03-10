# Technical Writing Standards - Complete Reference

## Five-Question Review Framework

When reviewing or self-editing any documentation, ask:

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

## Document Structure

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
- **Related Decisions**: Links to other ADRs
- **References**: Supporting materials

## Writing Process

1. Identify audience and document purpose
2. Create outline with key sections
3. Fill content in any order, use FAQ for homeless details
4. Edit and move inappropriate details to appendix
5. Write executive summary last
6. Review using the five-question framework

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

- Line length: 120 characters max
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

## AI Writing Anti-Patterns

These patterns are tells of AI-generated text. Avoid them to produce
clear, natural writing. Source: <https://tropes.fyi>

### Word Choice

- **Overused adverbs**: "quietly," "deeply," "fundamentally,"
  "remarkably," "arguably" — drop them or use specifics
- **Overused verbs/adjectives**: "delve," "utilize," "leverage,"
  "robust," "streamline," "harness" — use plain alternatives
- **Grandiose nouns**: "tapestry," "landscape," "paradigm," "synergy,"
  "ecosystem" — use concrete terms
- **"Serves as" dodge**: Don't replace "is" with "serves as," "stands
  as," "marks," or "represents"

### Sentence Structure

- **"It's not X — it's Y"**: False profundity via negation-reframe
- **"Not X. Not Y. Just Z."**: Dramatic countdown for manufactured
  tension
- **"The X? A Y."**: Self-posed rhetorical question answered for drama
- **Anaphora abuse**: Repeating identical sentence openings
- **Tricolon abuse**: Overusing rule-of-three patterns
- **Filler transitions**: "It's worth noting," "It bears mentioning,"
  "Importantly," "Interestingly," "Notably"
- **Tacked-on "-ing" phrases**: "...highlighting its importance" adds
  shallow meaning without substance
- **False ranges**: "From X to Y" where items aren't on a meaningful
  scale
- **Gerund fragment litany**: Verbless gerund fragments strung together

### Tone

- **False suspense**: "Here's the kicker," "Here's the thing," "Here's
  where it gets interesting"
- **Patronizing analogies**: "Think of it as..." assuming readers need
  metaphors
- **"Imagine a world where..."**: Futuristic sales pitch openings
- **False vulnerability**: Performative self-awareness or bias admission
- **"The truth is simple"**: Asserting clarity without proving claims
- **Stakes inflation**: Elevating mundane topics to world-historical
  importance
- **Pedagogical voice**: "Let's break this down," "Let's unpack this,"
  "Let's explore" — condescending for expert audiences
- **Vague attributions**: Unnamed "experts," "observers," "industry
  reports"
- **Invented concept labels**: Compound labels like "supervision
  paradox" or "acceleration trap" without grounding

### Formatting

- **Em dash overuse**: One or two per document is fine; more is a tell.
  Use commas, parentheses, or separate sentences instead
- **Bold-first bullets**: Every list item starting with bolded lead-in
- **Unicode decoration**: Arrows (→), smart quotes, special characters
  that wouldn't be typed naturally. Use ASCII ligature sequences instead
  (e.g., -> for arrows, => for fat arrows, != for not-equal)

### Composition

- **Fractal summaries**: Repeating "what I'll tell you; what I'm
  telling you; what I told you" at every level
- **Dead metaphors**: Beating a single metaphor across an entire piece
- **One-point dilution**: Restating a single argument many ways across
  thousands of words
- **Content duplication**: Repeating sections verbatim within the same
  piece
- **Signposted conclusions**: "In conclusion," "To sum up," "In
  summary" — just conclude
- **"Despite its challenges..."**: Acknowledging problems only to
  immediately dismiss them with optimism
