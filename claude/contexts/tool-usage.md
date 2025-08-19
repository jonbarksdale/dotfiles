# Tool Usage Standards

## File Creation and Modification

### Primary Rules
- **ALWAYS use Write, Edit, or MultiEdit tools** for creating or modifying files
- **NEVER use echo with output redirection** (>, >>) to write file content
- **NEVER use cat with heredoc** to create files

### Rationale
Tool-based file operations provide:
- Better visibility into file changes
- Proper error handling and validation
- Integration with development workflow
- Reduced bash complexity requiring manual tool approvals

### Script Creation Standards
- Use Write tool for verification scripts, configuration files, and code files
- Follow proper file permissions and location standards
- Document script purpose with ABOUTME comments per main standards
- Create executable scripts with appropriate shebang lines

### Best Practices
- Use absolute paths when specifying file locations
- Validate file content before writing when possible
- Maintain consistent file organization (e.g., scripts in ./scripts/)
- Ensure created files follow project conventions and standards