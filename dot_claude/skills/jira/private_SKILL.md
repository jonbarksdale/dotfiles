---
name: jira
description: Atlassian Jira integration via MCP. Auto-triggers when working with Jira issues, tickets, epics, or project management. Supports searching, creating, updating issues, transitions, comments, and linking.
context: fork
---

# Jira Integration

Use Atlassian MCP tools for Jira operations. This skill runs in a forked context to preserve the main conversation.

## Response Format

When returning results to the main conversation, provide:
1. Concise summary of findings (not full issue descriptions)
2. Key metadata (issue key, status, assignee, priority)
3. Relevant details only (not every field)
4. Action items or blockers if applicable

## Essential MCP Tools

| Operation | Tool | Use Case |
|-----------|------|----------|
| Search | `mcp__atlassian__searchJiraIssuesUsingJql` | Find issues by JQL query |
| Get Issue | `mcp__atlassian__getJiraIssue` | Retrieve full issue details |
| Create | `mcp__atlassian__createJiraIssue` | Create new issues |
| Update | `mcp__atlassian__editJiraIssue` | Modify existing issues |
| Transitions | `mcp__atlassian__getTransitionsForJiraIssue` | Get available status changes |
| Transition | `mcp__atlassian__transitionJiraIssue` | Change issue status |
| Comment | `mcp__atlassian__addCommentToJiraIssue` | Add comments to issues |
| User Lookup | `mcp__atlassian__lookupJiraAccountId` | Find user account IDs |
| Projects | `mcp__atlassian__getVisibleJiraProjects` | List available projects |
| Issue Types | `mcp__atlassian__getJiraProjectIssueTypesMetadata` | Get project issue types |

## Quick JQL Patterns

```jql
# Issues assigned to current user
assignee = currentUser() AND status != Done

# Open issues in a project
project = "PROJ" AND status NOT IN (Done, Closed)

# Recently updated by me
updatedBy = currentUser() AND updated >= -7d

# Epics in a project
project = "PROJ" AND issuetype = Epic

# Issues with specific label
labels = "infrastructure" AND status = "In Progress"

# Dependencies (blocks/is blocked by)
issue in linkedIssues("PROJ-123", "blocks")
```

## Issue Linking

The MCP does not currently support creating issue links directly. Use the bundled script:

```bash
~/.claude/skills/jira/jira-link-issues PROJ-123 PROJ-456 "Depends On"
```

Common link types:
- `Depends On` / `Dependency of` - Use for dependencies between issues
- `Blocks` / `Is Blocked By` - Use for blocking relationships
- `Relates To` - General relationship
- `Clones` / `Is Cloned By` - For cloned issues

## Workflow Guidance

1. **Search first**: Always search before creating to avoid duplicates
2. **Verify project access**: Check `mcp__atlassian__getVisibleJiraProjects` for available projects
3. **Look up users**: Use `mcp__atlassian__lookupJiraAccountId` before assigning
4. **Check transitions**: Get available transitions before changing status
5. **Link dependencies**: Use "Depends On" link type for dependency chains

## Common Workflows

### Finding Issues
1. Search with JQL: `mcp__atlassian__searchJiraIssuesUsingJql`
2. Get full details: `mcp__atlassian__getJiraIssue`
3. Summarize key points for main conversation

### Creating Issues
1. Get project metadata: `mcp__atlassian__getJiraProjectIssueTypesMetadata`
2. Look up assignee: `mcp__atlassian__lookupJiraAccountId`
3. Create issue: `mcp__atlassian__createJiraIssue`
4. Link to related issues if needed

### Updating Status
1. Get available transitions: `mcp__atlassian__getTransitionsForJiraIssue`
2. Execute transition: `mcp__atlassian__transitionJiraIssue`
3. Add comment explaining the change if appropriate

### Linking Issues
1. Identify source and target issues
2. Run: `~/.claude/skills/jira/jira-link-issues SOURCE TARGET "Link Type"`
3. Verify link was created

## Error Handling

If MCP tools return errors, inform the user with specific guidance:

| Error | User Message |
|-------|--------------|
| 401/403 Unauthorized | "Jira authentication failed. Please run `/mcp` to reconnect the Atlassian service." |
| 404 Not Found | "Issue or project not found. Please verify the key is correct." |
| 400 Bad Request | "Invalid field values. Check required fields for this issue type." |
| MCP unavailable | "Atlassian MCP is not connected. Please run `/mcp` to connect." |

Always surface authentication issues clearly so the user can resolve them.

See [reference.md](./reference.md) for complete JQL syntax and MCP tool documentation.
