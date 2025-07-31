Help me create an atomic commit following the standards in @~/.claude/contexts/commit-message.md.

First, analyze the current state:
1. Show git status and git diff to understand changes
2. Verify this represents a single logical change (atomic commit)
3. If changes span multiple concerns, suggest splitting into separate commits

Then craft a commit message using the standards from the context file, ensuring proper type prefix and adherence to the seven rules.

Remember: NEVER use --no-verify when committing.

## Example usage

/commit
/commit "focus area or specific context"