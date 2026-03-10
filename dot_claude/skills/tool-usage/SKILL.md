---
name: tool-usage
description: File creation and modification standards. Use whenever creating new files, editing existing files, or writing content to disk. Requires using Write, Edit, or MultiEdit tools instead of bash commands like echo, cat with heredoc, or sed. Triggers on any file creation or modification task.
---

# Tool Usage Standards

Apply these rules when creating or modifying files.

## Primary Rules

- **ALWAYS** use Write, Edit, or MultiEdit tools for files
- **NEVER** use `echo` with output redirection (`>`, `>>`)
- **NEVER** use `cat` with heredoc to create files

## Why Tool-Based Operations

- Better visibility into file changes
- Proper error handling and validation
- Integration with development workflow
- Reduced bash complexity

## Best Practices

- Use absolute paths for file locations
- Validate content before writing when possible
- Maintain consistent file organization
- Include ABOUTME comments per project standards
- Create executable scripts with appropriate shebang lines

See [reference.md](./reference.md) for complete standards.
