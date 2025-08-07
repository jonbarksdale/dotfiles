# About your human

- My name is Jon. I am a software engineer with over 20 years of experience in the industry, focusing on distributed systems, java based languages and runtimes, and data.

## Our relationship

- Consider us a team, working together to solve problems.
- ALWAYS ask for clarification rather than making assumptions.
- Ask for help when you are struggling.
- After completing work, you MUST self review honestly and precisely, highlighting nuance and errors of omission in addition to errors in the content.
  - You can address found issues before stopping.
- I ALWAYS want to know if I am wrong or missing context or nuance. When you you push back against a bad idea, cite evidence.

# Writing code

- CRITICAL: NEVER USE --no-verify WHEN COMMITTING CODE
- Commit every atomic change to ensure commits are cohesive and small enough to review
- We prefer simple, clean, maintainable solutions over clever or complex ones, even if the latter are more concise or performant. Readability and maintainability are primary concerns.
- Make the smallest reasonable changes to get to the desired outcome. You MUST ask permission before reimplementing features or systems from scratch instead of updating the existing implementation. This includes throwing away old implementations to rewrite from scratch - always get explicit permission first.
- When modifying code, match the style and formatting of surrounding code, even if it differs from standard style guides. Consistency within a file is more important than strict adherence to external standards.
- NEVER make code changes that aren't directly related to the task you're currently assigned. If you notice something that should be fixed but is unrelated to your current task, document it in a new issue instead of fixing it immediately.
- NEVER remove code comments unless you can prove that they are actively false. Comments are important documentation and should be preserved even if they seem redundant or unnecessary to you.
- All code files should start with a brief 2 line comment explaining what the file does. Each line of the comment should start with the string "ABOUTME: " to make it easy to grep for.
- When writing comments, avoid referring to temporal context about refactors or recent changes. Comments should be evergreen and describe the code as it is, not how it evolved or was recently changed.
- **Document Assumptions**: Clearly document any assumptions made during implementation.
- NEVER implement a mock mode for testing or for any purpose. We always use real data and real APIs, never mock implementations.
- NEVER name things as 'improved' or 'new' or 'enhanced', etc. Code naming should be evergreen. What is new today will be "old" someday.

## Performance Considerations

- Consider latency implications in distributed system changes
- Document performance assumptions and trade-offs when making architectural decisions
- Prefer explicit performance characteristics over assumptions (measure, don't guess)

# Testing

- Tests MUST cover the functionality being implemented.
- NEVER ignore the output of the system or the tests - Logs and messages often contain CRITICAL information.
- TEST OUTPUT MUST BE PRISTINE TO PASS
- If the logs are supposed to contain errors, capture and test it.
- NO EXCEPTIONS POLICY: Under no circumstances should you mark any test type as "not applicable". Every project, regardless of size or complexity, MUST have unit tests, integration tests, AND end-to-end tests. If you believe a test type doesn't apply, you need the human to say exactly "I AUTHORIZE YOU TO SKIP WRITING TESTS THIS TIME"

# Agent Verification Standards

## CRITICAL: Test Before Claiming Complete

**Never mark implementation as "complete" without actually running/testing it.**

This simple rule prevents false completion claims:

- **Run the code** you just wrote with real data
- **Test configurations** with actual files  
- **Verify integrations** work with real systems
- **Confirm functionality** does what it claims

Implementation agents have specific verification requirements in their individual agent files. The key principle: **if you didn't test it, don't claim it works.**

## We practice TDD

- Write tests before writing the implementation code
- Only write enough code to make the failing test pass
- Refactor code continuously while ensuring tests still pass

# Writing Documentation

## Core Writing Principles

- **Reader-centric approach**: Your reader is your customer - optimize for their time over yours
- Don't make readers do math or jump around documents - include calculations and duplicate small content if helpful  
- Define acronyms at first usage to remove ambiguity
- Avoid weasel words - use data when possible or remove vague qualifiers
- Don't bury the lede - start with conclusions, write executive summary last

## Document Structure (for technical docs)

1. **Executive Summary** (write last)
2. **Purpose Statement** - clear document goal
3. **Problem Statement** - from customer's perspective  
4. **Requirements** - core constraints that impact solution
5. **Approach** - solution strategy and trade-offs
6. **Solution Details** - detailed design information
7. **Appendix** - FAQ, glossary, alternatives, references

## Review Framework (Code & Documentation)

When reviewing any work, ask these five questions:

1. Is the problem clear?
2. Is the plan clear?
3. Does the plan make sense (solve problem, trade-offs reasonable)?
4. Are details faithful to the plan?
5. Are there low/no-risk ways to improve?

## Diagram Standards

- Always include a legend unless following strict UML
- Keep colors, shapes, sizes consistent within and across documents
- Prefer sequence diagrams over numbered block diagrams for call ordering

# Context Files

- **Commit messages**: @~/.claude/contexts/commit-message.md - Use when creating git commits
- **Technical writing**: @~/.claude/contexts/technical-writing.md - Use for documentation
- **Universal prompt template**: @~/.claude/contexts/universal-prompt-template.md - Use for creating/editing new prompts or commands
